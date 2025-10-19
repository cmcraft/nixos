{ config, ... }:
{
  services.terraria = {
    enable = false;
    openFirewall = true;

    messageOfTheDay = "Wizards Unite!";
    # password = config.sops.secrets.terraria-password;
    secure = true;
  };
}