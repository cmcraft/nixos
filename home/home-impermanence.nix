{ ... }:
{
  home.persistence."/persist" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Pictures/screenshots"
      "Documents"
      "Videos"
      "vivi"
      "comfy"
      "comfy/comfy-outputs"
      "comfy/comfy-models"
      ".claude"
      ".gnupg"
      ".ssh"
      ".mozilla"
      ".themes"
      ".nixops"
      ".lmstudio"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".cache"
      ".config"
      ".config/alacritty"
      ".config/autostart"
      ".config/blender"
      ".config/btop"
      ".config/environment.d"
      ".config/fastfetch"
      ".config/fontconfig"
      ".config/forge"
      ".config/gdu"
      ".config/git"
      ".config/gtk-3.0"
      ".config/gtk-4.0"
      ".config/hypr"
      ".config/mako"
      ".config/nvim"
      ".config/fish"
      ".config/dconf"
      ".config/Code"
      ".config/Kvantum"
      ".config/Vencord"
      ".config/sops/age"
      ".icons"
      ".vscode"
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