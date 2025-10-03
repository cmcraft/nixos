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
    ./gtk.nix
    ./modules/hyprland/hyprland.nix
    ./modules/waybar/waybar.nix
  ];
  
  home.username = "cmcraft";
  home.homeDirectory = "/home/cmcraft";

  home.file."Pictures/wallapapers".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/wallpapers";

  xdg.enable = true;
  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
  };

  programs.bash.enable = true;

  services.wpaperd.enable = true;
  services.wpaperd.settings = {
    default = {
      duration = "30m";
      mode = "center";
      sorting = "random";
    };
    any = {
      path = "/home/cmcraft/Pictures/wallapapers";
    };
  };

  programs.git = {
    enable = true;
    userName = "Constantine Craft";
    userEmail = "constantine.craft630@gmail.com";
    extraConfig = {
      init.defaultBranch = "master";
      safe.directory = "/etc/nixos";
      # safe.directory = "/home/cmcraft/.dotfiles";
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.11";
}