{ config, pkgs, ... }: 
{

  imports = [
    ./home.nix
    ./packages.nix
    ./modules/alacritty/alacritty.nix
    ./modules/cliphist/cliphist.nix
    ./modules/feh/feh.nix
    ./modules/firefox/firefox.nix
    ./modules/hypridle/hypridle.nix
    ./modules/hyprland/hyprland.nix
    ./modules/hyprlock/hyprlock.nix
    ./modules/mako/mako.nix
    ./modules/nnn/nnn.nix
    ./modules/rofi/rofi.nix
    ./modules/vscode/vscode.nix
    ./modules/waybar/waybar.nix
    ./modules/wpaperd/wpaperd.nix
  ];

  home.file."Pictures/wallapapers".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/wallpapers";

  xdg.enable = true;
  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    GRIMBLAST_EDITOR = "feh";
  };

}