# sudo nix \
#   --experimental-features "nix-command flakes" \
#   run github:nix-community/disko -- \
#   --mode disko /tmp/disko-elysium.nix

# _____ FOR REF ONLY _____ #
# btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
# umount /mnt
# _____ _____ #

# sudo nixos-generate-config --no-root-password --no-filesystems --root /mnt
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            plainSwap = {
              priority = 2;
              label = "swap";
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            root = {
              priority = 3;
              label = "nixos";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "nixoelysium" "-f" ]; # Override existing partition
                # Make a blank snapshot for Impermanence
                postCreateHook = /* sh */ ''
                  MNTPOINT=$(mktemp -d)
									mount "/dev/nvme0n1p3" "$MNTPOINT" -o subvol=/
									trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
                  btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
                ''
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                  };
                  # Subvolume name is the same as the mountpoint
                  "/home" = {
                    mountOptions = [ "subvol=home" "compress=zstd" "noatime" ];
                    mountpoint = "/home";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "/persist" = {
                    mountOptions = [
                      "subvol=persist"
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/persist";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "/nix" = {
                    mountOptions = [
                      "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "/log" = {
                    mountOptions = [
                      "subvol=log"
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/var/log";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}