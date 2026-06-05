{ config, ... }:
{
  services.terraria = {
    enable = false;
    openFirewall = true;

    messageOfTheDay = "Wizards Unite!";
    password = config.sops.templates."terraria".path;
    secure = true;
  };

  sops.secrets = {
    "terraria/password" = { };
  };

  sops.templates."terraria".content = ''
    {
      "journeypermission_time_setmidnight" : "2",
      "journeypermission_rain_setfrozen" : "2",
      "journeypermission_godmode" : "2",
      "port" : "7777",
      "password" : "${config.sops.placeholder."terraria/password"}",
      "journeypermission_setspawnrate" : "2",
      "journeypermission_time_setdusk" : "2",
      "journeypermission_rain_setstrength" : "2",
      "journeypermission_biomespread_setfrozen" : "2",
      "banlist" : "banlist.txt",
      "upnp" : "0",
      "journeypermission_time_setnoon" : "2",
      "priority" : "1",
      "secure" : "0",
      "journeypermission_time_setspeed" : "2",
      "npcstream" : "15",
      "maxplayers" : "8",
      "journeypermission_time_setfrozen" : "2",
      "journeypermission_time_setdawn" : "2",
      "motd" : "Wizards Unite!",
      "language" : "en-US",
      "journeypermission_wind_setfrozen" : "2",
      "difficulty" : "1",
      "autocreate" : "2",
      "journeypermission_setdifficulty" : "2",
      "journeypermission_wind_setstrength" : "2",
      "journeypermission_increaseplacementrange" : "2"
    }
  '';

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/terraria"
    ];
  };
}