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
      ".config/Code"
      ".config/sops/age"
      {
        directory = ".local/share/Steam";
      }
    ];
    files = [
      ".screenrc"
    ];
  };
  home.stateVersion = "25.11";
}