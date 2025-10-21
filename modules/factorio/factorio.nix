{ config, ... }:
{
  services.factorio = {
    enable = false;
    stateDirName = "factorio";

    admins = ["cmcraft"];

    game-name = "Constantine's Rimworld";
    description = "Constantine's Crazy Cosmonauts!";

    lan = true;
    public = true;
    loadLatestSave = true;
    openFirewall = true;
    requireUserVerification = true;

    username = "cmcraft";
    extraSettingsFile = config.sops.templates."factorio/extraSettingsFile".path;
  };
}