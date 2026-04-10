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

  systemd.services.podman-auto-update = {
    description = "Podman Auto-Update Service";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Runs the built-in podman auto-update command
      ExecStart = "${pkgs.podman}/bin/podman auto-update";
      # Optional: cleans up old images after updating
      ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
    };
  };

  systemd.timers.podman-auto-update = {
    description = "Timer for Podman Auto-Update Service";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "03:30";
      Persistent = true; # Run immediately if the last scheduled time was missed
    };
  };

}