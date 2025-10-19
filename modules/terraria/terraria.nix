{ config, ... }:
{
  services.terraria = {
    enable = true;
    openFirewall = true;

    messageOfTheDay = "Wizards Unite!";
    password = config.sops.secrets.terraria-password;
    secure = true;
  };
}