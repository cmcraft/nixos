{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hyprland-keybinds.nix
    ./hyprland-rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      exec-once = [
        "nm-applet &"
        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "waybar &"
        "swww-daemon &"
        # "hyprlock"
      ];
    };
  };

  # xdg.portal = {
  #     enable = true;
  #     extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  # };
}