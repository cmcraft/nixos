{ ... }:
{
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      # Publish hostname on local network for mDNS resolution
      domain = true;
    };
    # Ensure Avahi works correctly with systemd-resolved
    nssmdns4 = true;
    nssmdns6 = true;
  };
}