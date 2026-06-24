{ config, pkgs, ... }:
{
  imports = [
    ../tailscale/common.nix
  ];
  # 1. Enable the service and the firewall
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.templates."tailscale-auth-basic".path;
  };

  sops.secrets = {
    "tailscale/auth-key" = { };
  };

  sops.templates."tailscale-auth-basic".content = ''
      ${config.sops.placeholder."tailscale/auth-key"}
  '';
}