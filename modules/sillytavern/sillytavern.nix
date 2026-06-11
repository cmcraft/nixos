{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      sillytavern = prev.sillytavern.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          # Globally replace the hardcoded paths with Lemonade's expected standard OpenAI route
          sed -i 's|/api/sdapi/v1/txt2img|/v1/images/generations|g' src/endpoints/stable-diffusion.js
          sed -i 's|/sdapi/v1/txt2img|/v1/images/generations|g' src/endpoints/stable-diffusion.js

          # 2. Intercept the JSON response stream and reshape OpenAI format to WebUI format
          substituteInPlace src/endpoints/stable-diffusion.js \
          --replace "const data = await response.json();" \
                    "let data = await response.json(); if (data && data.data \&\& data.data[0] \&\& data.data[0].b64_json) { data = { images: [data.data[0].b64_json] }; }"
        
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