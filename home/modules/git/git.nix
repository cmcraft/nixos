{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Constantine Craft";
        email = "constantine.craft630@gmail.com";
      };
      init.defaultBranch = "master";
      safe.directory = "/etc/nixos";
      # safe.directory = "/home/cmcraft/.dotfiles";
    };
  };
}