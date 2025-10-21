{ config, ... }:
{
  services.terraria = {
    enable = true;
    openFirewall = true;

    messageOfTheDay = "Wizards Unite!";
    password = config.sops.secrets."terraria".path;
    secure = true;
  };
}