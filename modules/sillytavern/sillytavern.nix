{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      sillytavern = prev.sillytavern.overrideAttrs (oldAttrs: {
        # Modify source code strings directly after compilation unpack steps
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace src/endpoints/stable-diffusion.js \
          --replace "const url = \`''${serverUrl}/api/sdapi/v1/txt2img\`;" "const url = \`''${serverUrl}/v1/images/generations\`;"

        '';
      });
    })
  ];

  services.sillytavern = {
    enable = true;
    configFile = "${config.sops.templates."sillytavern-config".path}";
    user = "sillytavern";
    group = "sillytavern";

  };

  systemd.services.sillytavern = {
    serviceConfig = {
      ExecStartPre = [
        "+${pkgs.coreutils}/bin/mkdir -p /var/lib/SillyTavern"
        "+${pkgs.coreutils}/bin/rm -f /var/lib/SillyTavern/config.yaml"
        "+${pkgs.coreutils}/bin/cp -f ${config.sops.templates."sillytavern-config".path} /var/lib/SillyTavern/config.yaml"
        "+${pkgs.coreutils}/bin/chown -R sillytavern:users /var/lib/SillyTavern"
        "+${pkgs.coreutils}/bin/chmod -R 0775 /var/lib/SillyTavern"
      ];

      ExecStart = [
        "" # empty old command
        "${config.services.sillytavern.package}/bin/sillytavern --configPath /var/lib/SillyTavern/config.yaml"
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8045 ];
  };

  users.users.sillytavern = {
    isSystemUser = true;
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/var/lib/SillyTavern"; user = "sillytavern"; group = "users"; mode = "u=rwx,g=rwx,o=rx"; }
    ];
  };

  sops.secrets = {
    "sillytavern/username" = { };
    "sillytavern/password" = { };
  };

  sops.templates."sillytavern-config".content = ''
    listen: true
    port: 8045
    whitelistMode: false
    
    basicAuthMode: true
    basicAuthUser:
      username: "${config.sops.placeholder."sillytavern/username"}"
      password: "${config.sops.placeholder."sillytavern/password"}"
  '';
}