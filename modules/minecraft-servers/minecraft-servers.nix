{config, cozycraft, ... }:
{
  services.minecraft = {
    enable = true;
    openFirewall = true;

    servers = {
      burnt-toast = {
        type = "forge";
        symlinks = {
          mods = "${cozycraft}/mods";
          config = "${cozycraft}/config";
        };
        serverProperties = {
          "server-port" = 25565;
          difficulty = "normal";
          "max-players" = 10;
        };
      };
    };
  };
}