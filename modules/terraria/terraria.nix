{ config, ... }:
{
  services.terraria = {
    enable = false;
    openFirewall = true;

    messageOfTheDay = "Wizards Unite!";
    password = config.sops.templates."terraria".path;
    secure = true;
  };
}