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
      ".claude"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".lmstudio"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".cache"
      ".config"
      ".config/fish"
      ".config/dconf"
      ".config/Code"
      ".config/sops/age"
      ".icons"
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