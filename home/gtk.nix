{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    nerd-fonts.ubuntu
    twemoji-color-font
    noto-fonts-emoji
    fantasque-sans-mono
    maple-mono.truetype-autohint
  ];

  gtk = {
    enable = true;
    font = {
      name = "UbuntuMono Nerd Font Propo";
      size = 12;
    };
    theme = {
      name = "dracula";
    };
    iconTheme = {
      name = "dracula";
    };
    cursorTheme = {
      name = "Bibata-Modern-Clasic";
      package = pkgs.bibata-cursors;
      size = 18;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 18;
  };
}
