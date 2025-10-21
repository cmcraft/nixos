{ config, ... }:
{
  services.terraria = {
    enable = false;
    openFirewall = true;

    messageOfTheDay = "Wizards Unite!";
    password = "$( cat ${config.sops.secrets."terraria/password".path})";
    secure = true;
  };
}