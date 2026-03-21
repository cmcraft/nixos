{ config, lib, appimageTools, fetchurl, pkgs, ... }:

with lib;

let
  cfg = config.services.lmstudio;

  # LM Studio AppImage - latest version as of 2026-03-20
  lmstudioVersion = "0.4.7-4";
  lmstudioAppImage = appimageTools.wrapAppImage {
    name = "lm-studio"; 
    src = fetchurl {
      url = "https://installers.lmstudio.ai/linux/x64/${lmstudioVersion}/LM-Studio-${lmstudioVersion}-x64.AppImage";
      sha256 = "05gzqq1vhl2jhyk0rs8x8881cx2rqdjhc0pnicag5y41pl3a1m6r";
    };
  };

  # Package that wraps the AppImage and exposes lms CLI
  lmstudioPackage = pkgs.runCommand "lm-studio" { } ''
    mkdir -p $out/bin
    cp ${lmstudioAppImage} $out/bin/LM-Studio.AppImage
    chmod +x $out/bin/LM-Studio.AppImage

    # Create lms wrapper script - uses the bundled lms binary from AppImage
    cat > $out/bin/lms <<EOF
#!/usr/bin/env bash
exec ${pkgs.bash}/bin/bash "$out/bin/LM-Studio.AppImage" lms "\$@"
EOF
    chmod +x $out/bin/lms

    # Create lm-studio wrapper for GUI
    cat > $out/bin/lm-studio <<EOF
#!/usr/bin/env bash
exec ${pkgs.bash}/bin/bash "$out/bin/LM-Studio.AppImage" "\$@"
EOF
    chmod +x $out/bin/lm-studio

    # Extract lms binary from AppImage for direct execution (more efficient)
    ${lmstudioAppImage} --appimage-extract 2>/dev/null || true
    if [ -f squashfs-root/usr/bin/lms ]; then
      cp squashfs-root/usr/bin/lms $out/bin/lms-binary
      chmod +x $out/bin/lms-binary
      # Update lms wrapper to use extracted binary
      cat > $out/bin/lms <<EOF
#!/usr/bin/env bash
exec "$out/bin/lms-binary" "\$@"
EOF
      chmod +x $out/bin/lms
    fi
    rm -rf squashfs-root
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
      description = "Directory to store LM Studio data";
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
    environment.systemPackages = [ lmstudioPackage ];

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
          ${lmstudioPackage}/bin/lms server start \
            --host ${cfg.listenHost} \
            --port ${toString cfg.listenPort}
        '';
        ExecStop = ''
          ${lmstudioPackage}/bin/lms server stop
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