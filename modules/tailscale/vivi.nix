{ config, pkgs, ... }:
{
  imports = [
    ../tailscale/tailscale-lemonade.nix
  ];
  services.tailscale.settings.hostname = "vivi";
}