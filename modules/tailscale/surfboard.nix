{ config, pkgs, ... }:
{
  imports = [
    ../tailscale/tailscale.nix
  ];
  services.tailscale.settings.hostname = "SURFBoard";
}