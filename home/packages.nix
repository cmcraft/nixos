{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    alacritty
    inputs.swww.packages.${pkgs.system}.default
    # swww
    waybar
    rofi
    mako
    networkmanagerapplet

    #hyprland stuff
    # hyprpaper # maybe this as opposed to swww
    hyprpicker
    hypridle
    hyprlock
    
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}