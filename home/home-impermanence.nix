{ ... }:
{
  home.persistence."/persist/home/cmcraft" = {
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
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".screenrc"
    ];
    allowOther = true;
  };
  home.stateVersion = "25.11";
}