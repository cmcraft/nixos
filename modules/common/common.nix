{config, inputs, outputs, pkgs, ...}:
{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
  environment.variables = {
      EDITOR = "nvim";
    };

  environment.systemPackages = [
    pkgs.git
    pkgs.kitty
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.base16-schemes
    pkgs.unzip
    pkgs.patchelf
    pkgs.fastfetch

    pkgs.sops
    pkgs.age
    pkgs.ssh-to-age
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.initrd.systemd = {
    enable = true; # this enabled systemd support in stage1 - required for the below setup
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = ["initrd.target"];

      # LUKS/TPM process. If you have named your device mapper something other
      # than 'enc', then @enc will have a different name. Adjust accordingly.
      after = ["initrd-root-device.target"];

      # Before mounting the system root (/sysroot) during the early boot process
      before = ["sysroot.mount"];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the BTRFS root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/nvme0n1p3 /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines

        btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root
        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.enable = true;
  networking.dhcpcd.setHostname = true;

  time.timeZone = "America/Chicago";
  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;
  users.users.cmcraft = {
    isNormalUser = true;
    createHome = true;
    hashedPasswordFile = config.sops.secrets."cmcraft/password".path;
    home = "/home/cmcraft";
    useDefaultShell = false;
    shell = pkgs.fish;
    group = "cmcraft";
    extraGroups = [ "users" "wheel" "networkmanager" "comfyui" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGY+/Xe3OEDCmxq00H/MQu7XrJbkllgdho1VoN4PuL3k cmcraft@Remus" ];
  };
  users.groups.cmcraft = {};

  users.users.colord = {
    isSystemUser = true;
    group = "colord";
  };
  users.groups.colord = {};

}