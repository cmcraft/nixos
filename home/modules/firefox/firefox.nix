{ ... }:
{
  programs.firefox = {
    enable = true;
    profiles.cmcraft.settings = {

    };
  };
  stylix = {
    targets = {
      firefox = {
        profileNames = [
          "cmcraft"
        ];
      };
    };
  };
}