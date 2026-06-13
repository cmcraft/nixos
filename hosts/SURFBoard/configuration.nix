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
    ../../modules/common/common.nix
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
    ../../modules/tailscale/tailscale.nix
    ../../modules/xserver/xserver.nix
  ];
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings = {
    download-buffer-size = 524288000;
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

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
  
  environment.systemPackages = [

    # gaming stuff that aren't modules
    pkgs.bottles
    pkgs.heroic
    pkgs.lutris
    pkgs.mangohud
    pkgs.protonup-qt
    pkgs.steamcmd
    pkgs.steamguard-cli
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      cmcraft = import ../../home/home-gui.nix;
    };
  };

  networking.hostName = "SURFBoard";

  system.stateVersion = "26.05"; # Did you read the comment?

}