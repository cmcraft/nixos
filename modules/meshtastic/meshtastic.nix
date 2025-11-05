{ inputs, config, ... }:
{
  services.meshtastic = {
    enabled = true;
    openFirewall = true;
    enableAutodiscovery = true;
  };
}