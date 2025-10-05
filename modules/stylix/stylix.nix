{ 
  nix-config,
  config,
  pkgs,
  ... 
}:

let 
  opacity = 0.95;
  fotSize = 11;
in 
{
  imports = with nix-config.inputs.stylix.nixosModules; [ stylix ];

  stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    opacity = {
      terminal = opacity;
      popups = opacity;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 18;
    };

    fonts = {
      serif = {
        package = pkgs.aleo-fonts;
        name = "Aleo";
      };

      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK JP";
      };

      monospace = {
        package = pkgs.maple-mono.variable;
        name = "Maple Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = fontSize;
        desktop = fontSize;
        popups = fontSize;
        terminal = fontSize;
      };
    };
  };
}