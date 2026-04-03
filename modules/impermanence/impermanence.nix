{ ... }:
{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/home-assistant"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/secureboot"
      "/var/db/sudo"
      "/var/lib/bluetooth"
      "/var/lib/containers"
      "/var/lib/containers/storage/factorio"
      "/var/lib/containers/storage/lemonade/lemonade-llama"
      "/var/lib/containers/storage/lemonade/models"
      "/var/lib/containers/storage/lemonade/config"
      "/var/lib/containers/storage/minecraft"
      "/var/lib/containers/storage/redbot"
      "/var/lib/containers/storage/redbot/core/logs"
      "/var/lib/containers/storage/strix-halo/comfyui"
      "/var/lib/containers/storage/terraria"
      "/var/lib/containers/storage/terraria/config"
      "/var/lib/hass"
      "/var/lib/llama-cpp/models"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/terraria"
      "/var/lib/zigbee2mqtt"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      { directory = "/var/lib/containers/storage/onyx/db"; user = "999"; group = "999"; mode = "0700"; }
      { directory = "/var/lib/containers/storage/onyx/config"; user = "1000"; group = "1000"; mode = "0755"; }
      { directory = "/var/lib/containers/storage/onyx/index"; user = "1000"; group = "1000"; mode = "0755"; }

      # { directory = "/var/lib/comfyui"; user = "comfyui"; group = "comfyui"; mode = "0750"; }
      # { directory = "/var/lib/open-webui"; mode = "0700"; }
      # { directory = "/var/lib/open-webui/data"; mode = "0700"; }
      # { directory = "/var/lib/factorio"; user = "factorio"; group = "factorio"; mode = "u=rwx,g=rx,o="; }
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