{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lmstudio;
  appimageTools = pkgs.appimageTools;
  fetchurl = pkgs.fetchurl;

  # LM Studio AppImage - latest version as of 2026-03-20
  lmstudioVersion = "0.4.7-4";
  lmstudioSrc = fetchurl {
    url = "https://installers.lmstudio.ai/linux/x64/${lmstudioVersion}/LM-Studio-${lmstudioVersion}-x64.AppImage";
    sha256 = "05gzqq1vhl2jhyk0rs8x8881cx2rqdjhc0pnicag5y41pl3a1m6r";
  };

  # Extract AppImage contents
  lmstudioExtracted = appimageTools.extractType1 {
    pname = "lm-studio";
    version = lmstudioVersion;
    src = lmstudioSrc;
  };

  # Wrap the extracted AppImage for system integration
  lmstudioWrapped = appimageTools.wrapType2 rec {
    name = "lm-studio";
    pname = "lm-studio";
    version = lmstudioVersion;
    src = lmstudioSrc;

    extraInstallCommands = ''
      # Copy all extracted files to output
      cp -r ${lmstudioExtracted}/* $out/
      chmod +x $out/AppRun

      # Update desktop file to use correct exec
      substituteInPlace --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
        $out/share/applications/*.desktop || true
    '';

    meta = {
      description = "LM Studio - GUI for local LLM inference";
      homepage = "https://lmstudio.ai";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "lm-studio";
    };
  };

  # Extract and bundle the lms binary from the AppImage
  lmsBinary = pkgs.runCommand "lms-binary" { } ''
    mkdir -p $out/bin
    cp ${lmstudioExtracted}/resources/app/.webpack/lms $out/bin/lms
    chmod +x $out/bin/lms
  '';

  # CLI wrapper that uses the extracted lms binary directly
  lmstudioCLI = pkgs.writeShellScriptBin "lms" ''
    exec ${lmsBinary}/bin/lms "$@"
  '';

in {
  options.services.lmstudio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable LM Studio server as a systemd service";
    };

    user = mkOption {
      type = types.str;
      default = "root";
      description = "User to run LM Studio as";
    };

    group = mkOption {
      type = types.str;
      default = "users";
      description = "Group for LM Studio process";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/lmstudio";
      description = "Directory to store LM Studio data (persistent across reboots)";
    };

    listenHost = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Host to bind the LM Studio server to";
    };

    listenPort = mkOption {
      type = types.int;
      default = 1234;
      description = "Port for the LM Studio server";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall ports for LM Studio";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.users.users.${cfg.user} != null;
        message = "LM Studio user '${cfg.user}' does not exist";
      }
    ];

    # Expose lm-studio and lms CLI packages
    environment.systemPackages = [ lmstudioWrapped lmstudioCLI ];

    # Set up the data directory with proper ownership
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.lmstudio-server = {
      description = "LM Studio Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = cfg.dataDir;
        XDG_CONFIG_HOME = cfg.dataDir;
        XDG_DATA_HOME = cfg.dataDir;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${lmstudioCLI}/bin/lms server start \
            --bind ${cfg.listenHost} \
            --port ${toString cfg.listenPort}
        '';
        ExecStop = ''
          ${lmstudioCLI}/bin/lms server stop
        '';
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "lmstudio";
        CacheDirectory = "lmstudio";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listenPort ];
    };
  };
}