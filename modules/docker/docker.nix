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
    podman-tui   # Terminal mgmt UI for Podman
    passt    # For Pasta rootless networking
  ];
  
  virtualisation.oci-containers.containers = {
    container-name = {
      image = "phasecorex/red-discordbot:full";
      autoStart = true;
      volumes = [ "${toString ./.}/redbot:/data" ];
    };
  };
  # Add 'newuidmap' and 'sh' to the PATH for users' Systemd units. 
  # Required for Rootless podman.
  #systemd.user.extraConfig = ''
  #  DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${lib.makeBinPath [ pkgs.bash ]}"
  #'';
}

  #virtualisation.arion = {
  #  backend = "docker";
  #  projects = {
  #    redbot = {
  #      serviceName = "redbot";
  #      settings = {
  #        imports = [
  #          ./containers/redbot.nix
  #        ];
  #      };
  #    };
  #  };
  #};