{ pkgs, ... }:

{
  home.persistence."/persistent/home/cmcraft" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
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
}