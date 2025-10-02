{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    alacritty
    inputs.swww.packages.${pkgs.system}.default
    # swww
    # xdg-desktop-portal
    maple-mono
    rofi
    mako
    networkmanagerapplet

    #hyprland stuff
    # hyprpaper # maybe this as opposed to swww
    hyprpicker
    hypridle
    hyprlock
    
    inputs.zen-browser.packages.${pkgs.system}.default

    #stolen fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-emoji
    fantasque-sans-mono
    maple-mono.truetype-autohint
  ];
}