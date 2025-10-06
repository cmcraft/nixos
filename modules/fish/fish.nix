{ ... }:
{
  programs.fish = {
    enable = true;

    shellInit = ''
      fastfetch
    '';
  };
}