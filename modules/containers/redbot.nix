{ config, pkgs, ... }:

{
  imports = [
    ../containers/containers.nix
  ];
  
    virtualisation.oci-containers.containers = {
    redbot = {
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      image = "phasecorex/red-discordbot:full";
      autoStart = true;
      volumes = [ "/var/lib/containers/storage/redbot:/data" ];
      environmentFiles = [
        config.sops.templates."redbot".path
      ];
    };
  };

  sops.secrets = {
    "redbot/token" = { };
  };

  sops.templates."redbot".content = ''
    TOKEN=${config.sops.placeholder."redbot/token"}
    PREFIX=!
  '';

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/containers/storage/redbot"
      "/var/lib/containers/storage/redbot/core/logs"
    ];
  };
}