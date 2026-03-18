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
      ".gnupg"
      ".ssh"
      ".nixops"
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