{ ... }:
{
  home.persistence."/persist/home/cmcraft" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
      { directory = ".nixops"; mode = "0700"; }
      { directory = ".local/share/keyrings"; mode = "0700"; }
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
  home.stateVersion = "25.11";
}