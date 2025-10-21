{ config, ... }:
{
  services.terraria = {
    enable = true;
    openFirewall = true;

    messageOfTheDay = "Wizards Unite!";
    password = config.sops.templates."terraria".path;
    secure = true;
  };
}