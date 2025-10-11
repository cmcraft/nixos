{ ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      kbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type="rsa";
        bits= 4096;
      }
    ];
    allowSFTP = false; # Don't set this if you need sftp
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };
}