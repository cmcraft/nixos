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
}