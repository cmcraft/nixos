{ ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # passwordAuthentication = false;
    };
    hostKeys = [
      {
        path = "/per/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/per/etc/ssh/ssh_host_rsa_key";
        type="rsa";
        bits= 4096;
      }
    ];
  };
}