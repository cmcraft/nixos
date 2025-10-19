# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../modules/avahi/avahi.nix
    ../../modules/disko/disko-elysium.nix
    ../../modules/fish/fish.nix
    ../../modules/fuse/fuse.nix
    ../../modules/gamescope/gamescope.nix
    ../../modules/greetd/greetd.nix
    ../../modules/hyprland/hyprland.nix
    ../../modules/impermanence/impermanence.nix
    ../../modules/nm-applet/nm-applet.nix
    ../../modules/openssh/openssh.nix
    ../../modules/pipewire/pipewire.nix
    ../../modules/sops/sops.nix
    ../../modules/steam/steam.nix
    ../../modules/stylix/stylix.nix
    ../../modules/xserver/xserver.nix
  ];
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nix.settings = {
    download-buffer-size = 524288000;
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs.config.allowUnfree = true;

  environment.etc = { 
    nixos.source = "/persist/etc/nixos";
    "greetd/environments".text = ''
    Hyprland
    '';
    "NetworkManager/system-connections" = {
      source = "/persist/etc/NetworkManager/system-connections/";
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.EDITOR = "nvim";
  
  environment.systemPackages = [ 
    pkgs.kitty
    inputs.home-manager.packages.${pkgs.system}.default
    pkgs.base16-schemes

    # gaming stuff that aren't modules
    pkgs.bottles
    pkgs.heroic
    pkgs.lutris
    pkgs.mangohud
    pkgs.protonup-qt
    pkgs.steamcmd
    pkgs.steamguard-cli

    pkgs.sops
    pkgs.age
    pkgs.ssh-to-age
  ];

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

  networking.hostName = "remus"; 
  networking.networkmanager.enable = true;
  networking.dhcpcd.setHostname = true;  

  time.timeZone = "America/Chicago";
  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cmcraft = {
    isNormalUser = true;
    createHome = true;
    initialPassword = "password"; # Change this. Duh.
    hashedPasswordFile = config.sops.secrets."cmcraft/password".path;
    home = "/home/cmcraft";
    useDefaultShell = false;
    shell = pkgs.fish;
    group = "cmcraft";
    extraGroups = [ "users" "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [ ]; 
  };
  
  users.users.colord = {
    isSystemUser = true;
    group = "colord";
  };
  
  users.groups.cmcraft = {};
  users.groups.colord = {};

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      cmcraft = import ../../home/home.nix;
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}