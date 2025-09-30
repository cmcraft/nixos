{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    # inputs.swww.packages.${pkgs.system}.default
    swww
    # waybar
    rofi
    mako
    networkmanagerapplet

    #hyprland stuff
    # hyprpaper # maybe this as opposed to swww
    hyprpicker
    hypridle
    hyprlock
    
  ];
}