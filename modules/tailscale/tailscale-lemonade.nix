{ config, pkgs, ... }:
{
  imports = [
    ../tailscale/common.nix
  ];
  # 1. Enable the service and the firewall
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.templates."tailscale-auth-lemonade".path;
  };

  sops.secrets = {
    "tailscale/lemonade-auth-key" = { };
  };

  sops.templates."tailscale-auth-lemonade".content = ''
      ${config.sops.placeholder."tailscale/lemonade-auth-key"}
  '';
}