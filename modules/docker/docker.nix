{ config, pkgs, inputs, ... }:
{
  virtualisation =  {
    containers.enable = true;

    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
    }; # podman

    containers.storage.settings = {
      storage = {
        driver = "btrfs";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        options.overlay.mountopt = "nodev,metacopy=on";
      }; # storage
    };
  }; # virtualisation

  users.groups.podman = {
    name = "podman";
  };

  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman
    podman-compose
    podman-tui   # Terminal mgmt UI for Podman
    passt    # For Pasta rootless networking
    compose2nix
  ];
  
  virtualisation.oci-containers.containers = {
    redbot = {
      image = "phasecorex/red-discordbot:full";
      autoStart = true;
      volumes = [ "/var/lib/containers/storage/redbot:/data" ];
      environment = {
        TOKEN = config.sops.templates."redbot".path;
        PREFIX = "!";
      };
    };
  };

  virtualisation.oci-containers.containers = {
    factorio = {
      image = "factoriotools/factorio:stable";
      autoStart = true;
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
      autoStart = true;
      ports = [ 
        "7777:7777"
      ];
      volumes = [ 
        "/var/lib/containers/storage/terraria:/root/.local/share/Terraria/Worlds"
        "${config.sops.templates."terraria".path}:/config/serverconfig.txt"  
      ];
      environment = {
        CONFIGPATH = "/config";
        CONFIG_FILENAME = "serverconfig.txt";
        WORLD_FILENAME = "The_Turtle_Moves.wld";
      };
    };
  };
}