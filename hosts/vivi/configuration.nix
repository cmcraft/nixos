# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    ../../modules/avahi/avahi.nix
    ../../modules/common/common.nix
    ../../modules/disko/disko-elysium.nix
    ../../modules/fish/fish.nix
    ../../modules/fuse/fuse.nix
    ../../modules/fwupd/fwupd.nix
    ../../modules/hermes/hermes-agent.nix
    ../../modules/impermanence/impermanence.nix
    ../../modules/containers/lemonade.nix
    ../../modules/nm-applet/nm-applet.nix
    ../../modules/openssh/openssh.nix
    ../../modules/pipewire/pipewire.nix
    ../../modules/sops/sops.nix
    ../../modules/sillytavern/sillytavern.nix
    ../../modules/stylix/stylix.nix
    ../../modules/tailscale/tailscale-lemonade.nix
    ../../modules/tuned/tuned.nix
  ];

  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest;
  services.scx.enable = true;

  nix.settings = {
    download-buffer-size = 524288000;
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  environment.systemPackages = [
    pkgs.llama-cpp
    pkgs.clinfo
    pkgs.stable-diffusion-cpp-vulkan
    pkgs.tuned
  ];

  boot.kernelParams = [
    "amdgpu.gttsize=126976"
    "amdgpu.vis_vram_limit=126976"
    "ttm.pages_limit=32505856"
    "amd_iommu=on"
    "iommu=pt"
  ];

  boot.initrd.kernelModules = [ "amdgpu" "kvm-amd" "amdxdna"];

  hardware.graphics.extraPackages = with pkgs; [
    libdrm
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      cmcraft = import ../../home/home.nix;
    };
  };

  networking.hostName = "vivi";

  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [ 80 443 3000 8080 ];
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  users.groups.video = {};
  users.groups.render = {};

  system.activationScripts.amdgpu-ids = {
    text = ''
      mkdir -p /opt/amdgpu/share/libdrm
      ln -sfn ${pkgs.libdrm}/share/libdrm/amdgpu.ids /opt/amdgpu/share/libdrm/amdgpu.ids
    '';
  };

  system.stateVersion = "26.05";
}