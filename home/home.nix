{ config, pkgs, ... }: 
{

  imports = [
    ./modules/bash/bash.nix
    ./modules/btop/btop.nix
    ./modules/fastfetch/fastfetch.nix
    ./modules/git/git.nix
    ./modules/home-manager/home-manager.nix
    ./modules/neovim/neovim.nix
  ];

  home.username = "cmcraft";
  home.homeDirectory = "/home/cmcraft";

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE= "$HOME/.config/sops/age/keys.txt";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "26.05";
}