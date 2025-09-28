{ config, lib, pkgs, ... }:
{
  imports = [
    ./hyprland-rules.nix
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
  };
}