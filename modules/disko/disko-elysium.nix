# git clone https://github.com/cmcraft/nixos.git
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount --yes-wipe-all-disks ./modules/disko/disko-elysium.nix

# _____ FOR REF ONLY _____ #
# btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
# umount /mnt
# __________ #

# _____ FOR REF ONLY _____ #
# nix run --extra-experimental-features "nix-command flakes" nixpkgs#sops secrets/secrets.yaml
# __________ #

# cp repo to /persist/etc/nixos
# mkdir -p /mnt/persist/home/cmcraft/.config/sops/age/
# touch /mnt/persist/home/cmcraft/.config/sops/age/keys.txt
# cp secret to keys.txt
# sudo nixos-install --no-root-password --root /mnt --flake .#hostname

# _____ FOR REF ONLY _____ #
# convert an ssh ed25519 key to an age key
# mkdir -p ~/.config/sops/age
# nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
# then
# nix run nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
# __________ #

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
                  MNTPOINT=/mnt
									mount "/dev/nvme0n1p3" "$MNTPOINT" -o subvol=/
									trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
                  btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
                '';
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

  fileSystems."/home".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}