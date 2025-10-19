{ ... }:
{
  programs.git = {
    enable = true;
    user = {
      name = "Constantine Craft";
      email = "constantine.craft630@gmail.com";
    };
    settings = {
      init.defaultBranch = "master";
      safe.directory = "/etc/nixos";
      # safe.directory = "/home/cmcraft/.dotfiles";
    };
  };
}