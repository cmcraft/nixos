{ ... }:
{
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
      "/var/db/sudo"
      "/var/lib/bluetooth"
      "/var/lib/containers"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/containers/storage/redbot"
      "/var/lib/containers/storage/redbot/core/logs"
      "/var/lib/containers/storage/factorio"
      "/var/lib/containers/storage/terraria"
      "/var/lib/containers/storage/terraria/config"
      # { directory = "/var/lib/factorio"; user = "factorio"; group = "factorio"; mode = "u=rwx,g=rx,o="; }
      "/var/lib/hass"
      "/etc/home-assistant"
      "/var/lib/terraria"
      "/var/lib/zigbee2mqtt"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];

    files = [
      "/etc/machine-id"

      # Required for SSH. If you have keys with different algorithms, then
      # you must also persist them here.
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      # if you use docker or LXD, also persist their directories
    ];
  };
}