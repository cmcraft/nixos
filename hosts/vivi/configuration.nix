# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../modules/disko/disko-elysium.nix
    ../../modules/fish/fish.nix
    ../../modules/impermanence/impermanence.nix
    ../../modules/nm-applet/nm-applet.nix
    ../../modules/openssh/openssh.nix
    ../../modules/pipewire/pipewire.nix
    ../../modules/sops/sops.nix
    ../../modules/stylix/stylix.nix
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
    "greetd/environments".text = ''
      TTY
    '';
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.EDITOR = "nvim";

  # GPU / ROCm packages for LLM workloads
  boot.kernelPackages.nixpkgs.modules = [
    "hardware.firmware.amdgpu-firmware"
  ];

  environment.systemPackages = [
    pkgs.kitty
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.base16-schemes

    # Vulkan and ROCm for LLM workloads
    pkgs.vulkan-loader
    pkgs.radeon-vulkan

    # LM Studio CLI
    pkgs.lmstudio
    pkgs.fastfetch

    pkgs.sops
    pkgs.age
    pkgs.ssh-to-age
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "vivi";
  networking.networkmanager.enable = true;

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
    extraGroups = [ "users" "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [ ];
  };

  users.groups.cmcraft = {};

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      cmcraft = import ../../home/home.nix;
    };
  };

  system.stateVersion = "25.05";

}
