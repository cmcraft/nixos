{ config, pkgs, ... }:
{
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];

  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;

  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "example.ts.net" ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/tailscale"
    ];
  };
}