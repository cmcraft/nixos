{ ... }:
{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/home-assistant"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/secureboot"
      { directory = "/var/cache/llamacpp-rpc"; user = "llamacpp-rpc"; group = "llamacpp-rpc"; mode = "0755"; }
      "/var/db/sudo"
      "/var/lib/bluetooth"
      "/var/lib/comfyui"
      "/var/lib/containers"
      "/var/lib/containers/storage/factorio"
      "/var/lib/containers/storage/minecraft"
      "/var/lib/containers/storage/redbot"
      "/var/lib/containers/storage/redbot/core/logs"
      "/var/lib/containers/storage/strix-halo/comfyui"
      "/var/lib/containers/storage/terraria"
      "/var/lib/containers/storage/terraria/config"
      "/var/lib/hass"
      "/var/lib/llama-cpp"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/terraria"
      "/var/lib/zigbee2mqtt"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      { directory = "/var/lib/private/open-webui"; mode = "0700"; }
      { directory = "/var/lib/private/open-webui/data"; mode = "0700"; }
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