{ config, ... }:
{
  services.factorio = {
    enable = true;

    admins = ["cmcraft"];

    game-name = "Constantine's Rimworld";
    game-password = config.sops.secrets.factorio-password;
    description = "Constantine's Crazy Cosmonauts!";

    lan = true;
    public = true;
    loadLatestSave = true;
    openFirewall = true;
    requireUserVerification = true;

    username = "cmcraft";
    token = config.sops.secrets.factorio-token;
  };
}