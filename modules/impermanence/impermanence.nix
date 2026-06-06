{ ... }:
{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/secureboot"
      "/var/db/sudo"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      { directory = "/var/lib/colord"; user = "colord"; group = "users"; mode = "u=rwx,g=rwx,o=rw"; }
    ];

    files = [
      "/etc/machine-id"

      # Required for SSH. If you have keys with different algorithms, then
      # you must also persist them here.
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}