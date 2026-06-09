{ config, pkgs, ... }:

{
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
        "+${pkgs.coreutils}/bin/chown sillytavern:sillytavern /var/lib/SillyTavern/config.yaml"
        "+${pkgs.coreutils}/bin/chmod 0600 /var/lib/SillyTavern/config.yaml"
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
    "sillytavern/api-key" = { };
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