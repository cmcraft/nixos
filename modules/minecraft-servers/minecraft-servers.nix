{config, inputs, ... }:
{
  services.minecraft = {
    enable = true;
    openFirewall = true;

    servers = {
      burnt-toast = {
        type = "forge";
        symlinks = {
          mods = "${inputs.cozycraft}/mods";
          config = "${inputs.cozycraft}/config";
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