{ inputs, config, ... }:
{
  services.meshtastic = {
    enable = true;
    openFirewall = true;
    enableAutodiscovery = true;
    apiPort = "4403";
  };
}