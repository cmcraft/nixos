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
      volumes = [ "${virtualisation.containers.storage.settings.storage.graphroot}${toString ./.}/redbot:/data" ];
      environment = {
        token = config.sops.templates."redbot".path;
      };
    };
  };
}