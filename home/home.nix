{
  config,
  pkgs,
  ...
}: {

  imports = [
    ./packages.nix
    ./modules/hyprland/hyprland.nix
    ./modules/waybar/waybar.nix
  ];
  
  home.username = "cmcraft";
  home.homeDirectory = "/home/cmcraft";

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