{ ... }:
{
  home.persistence."/persist" = {
    directories = [
      ".cache"
      ".claude"
      ".config"
      ".config/alacritty"
      ".config/autostart"
      ".config/blender"
      ".config/btop"
      ".config/Code"
      ".config/dconf"
      ".config/environment.d"
      ".config/fastfetch"
      ".config/fish"
      ".config/fontconfig"
      ".config/forge"
      ".config/gdu"
      ".config/git"
      ".config/gtk-3.0"
      ".config/gtk-4.0"
      ".config/hypr"
      ".config/Kvantum"
      ".config/mako"
      ".config/nvim"
      ".config/qt5ct"
      ".config/qt6ct"
      ".config/rofi"
      ".config/sops/age"
      ".config/stylix"
      ".config/Vencord"
      ".gnupg"
      ".icons"
      ".lmstudio"
      ".local/share/direnv"
      ".local/share/keyrings"
      ".mozilla"
      ".nixops"
      ".ssh"
      ".themes"
      ".vscode"
      "comfy"
      "comfy/comfy-models"
      "comfy/comfy-outputs"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Pictures/screenshots"
      "Videos"
      "vivi"
      
      {
        directory = ".local/share/Steam";
      }
    ];
    files = [
      ".screenrc"
      ".bash_profile"
    ];
  };
  home.stateVersion = "26.05";
}