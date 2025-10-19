{
  config,
  pkgs,
  ...
}: 
let 
  pathToFile = "/etc/nixos/wallpapers";
in
{

  imports = [
    ./packages.nix
    ./modules/alacritty/alacritty.nix
    ./modules/bash/bash.nix
    ./modules/btop/btop.nix
    ./modules/cliphist/cliphist.nix
    ./modules/fastfetch/fastfetch.nix
    ./modules/feh/feh.nix
    ./modules/firefox/firefox.nix
    ./modules/git/git.nix
    ./modules/home-manager/home-manager.nix
    ./modules/hypridle/hypridle.nix
    ./modules/hyprland/hyprland.nix
    ./modules/hyprlock/hyprlock.nix
    ./modules/mako/mako.nix
    ./modules/neovim/neovim.nix
    # ./modules/network-manager-applet/network-manager-applet.nix
    ./modules/nnn/nnn.nix
    ./modules/rofi/rofi.nix
    ./modules/vscode/vscode.nix
    ./modules/waybar/waybar.nix
    ./modules/wpaperd/wpaperd.nix
    # ./modules/yazi/yazi.nix
  ];

  home.username = "cmcraft";
  home.homeDirectory = "/home/cmcraft";

  home.file."Pictures/wallapapers".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/wallpapers";

  xdg.enable = true;
  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    GRIMBLAST_EDITOR = "feh";
    SOPS_AGE_KEY_FILE= "$HOME/.config/sops/age/secrets/keys.txt;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.11";
}