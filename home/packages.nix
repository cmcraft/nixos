{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    alacritty
    # inputs.swww.packages.${pkgs.system}.default
    # swww
    # xdg-desktop-portal
    rofi
    mako
    networkmanagerapplet
    pavucontrol
    pamixer

    #hyprland stuff
    # hyprpaper # maybe this as opposed to swww
    waypaper
    hyprpicker
    hypridle
    hyprlock

    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}