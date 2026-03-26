{ ... }:
{
  home.persistence."/persist" = {
    directories = [
      "vivi"
      "Videos"
      "Pictures/screenshots"
      "Pictures"
      "Music"
      "Downloads"
      "Documents"
      "comfy/comfy-outputs"
      "comfy/comfy-models"
      "comfy"
      ".vscode"
      ".themes"
      ".ssh"
      ".nixops"
      ".mozilla"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".lmstudio"
      ".icons"
      ".gnupg"
      ".config/Vencord"
      ".config/sops/age"
      ".config/qt6ct"
      ".config/qt5ct"
      ".config/nvim"
      ".config/mako"
      ".config/Kvantum"
      ".config/hypr"
      ".config/gtk-4.0"
      ".config/gtk-3.0"
      ".config/git"
      ".config/gdu"
      ".config/forge"
      ".config/fontconfig"
      ".config/fish"
      ".config/fastfetch"
      ".config/environment.d"
      ".config/dconf"
      ".config/Code"
      ".config/btop"
      ".config/blender"
      ".config/autostart"
      ".config/alacritty"
      ".config"
      ".claude"
      ".cache"
      
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