{ config, pkgs, ... }:

{
  imports = [
    ../docker/docker.nix
  ];
  
    virtualisation.oci-containers.containers = {
    redbot = {
      image = "phasecorex/red-discordbot:full";
      autoStart = false;
      volumes = [ "/var/lib/containers/storage/redbot:/data" ];
      environmentFiles = [
        config.sops.templates."redbot".path
      ];
    };
  };

  virtualisation.oci-containers.containers = {
    factorio = {
      image = "factoriotools/factorio:stable";
      autoStart = false;
      ports = [ 
        "34197:34197/udp"
        "27015:27015/tcp"
      ];
      volumes = [ 
        "/var/lib/containers/storage/factorio:/factorio"
        "${config.sops.templates."factorio/server-settings".path}:/server-settings.json" 
      ];
    };
  };

  virtualisation.oci-containers.containers = {
    terraria = {
      image = "ryshe/terraria:latest";
      autoStart = false;
      ports = [ 
        "7777:7777"
      ];
      volumes = [ 
        "/var/lib/containers/storage/terraria:/root/.local/share/Terraria/Worlds"
        "${config.sops.templates."terraria".path}:/config/config.json"  
      ];
      environment = {
        CONFIGPATH = "/config";
        CONFIG_FILENAME = "config.json";
        WORLD_FILENAME = "The_Turtle_Moves.wld";
      };
    };
  };
}