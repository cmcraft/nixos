{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hyprland-keybinds.nix
    ./hyprland-rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      exec-once = [
        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "waybar &"
        "wpaperd -d"
      ];
    };
  };

}