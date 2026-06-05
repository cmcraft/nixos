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
    ../../modules/ddns-updater/ddns-updater.nix
    ../../modules/disko/disko-elysium.nix
    ../../modules/common/common.nix
    ../../modules/containers/containers.nix
    ../../modules/factorio/factorio.nix
    ../../modules/fish/fish.nix
    ../../modules/fuse/fuse.nix
    ../../modules/home-assistant/home-assistant.nix
    ../../modules/impermanence/impermanence.nix
    ../../modules/mosquitto/mosquitto.nix
    ../../modules/nm-applet/nm-applet.nix
    ../../modules/openssh/openssh.nix
    ../../modules/pipewire/pipewire.nix
    ../../modules/containers/redbot.nix
    ../../modules/sops/sops.nix
    ../../modules/stylix/stylix.nix
    ../../modules/terraria/terraria.nix
    ../../modules/zigbee2mqtt/zigbee2mqtt.nix
  ];
  
  environment.systemPackages = with pkgs; [
    docker-client
    arion

    ddns-updater
    factorio-headless
    home-assistant
    terraria-server

    usbutils
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      cmcraft = import ../../home/home.nix;
    };
  };

  networking.hostName = "romulus"; 

  system.stateVersion = "26.05"; # Did you read the comment?

}