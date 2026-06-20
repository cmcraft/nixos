{ config, pkgs, inputs, ... }:
{
  services.matrix-continuwuity = {
    enable = true;
    package = inputs.continuwuity.packages.${pkgs.stdenv.hostPlatform.system}.default;
    admin.enable = true;
    settings = {
      global = {
        address = [ "0.0.0.0" ];
        server_name = "knit-purl-binary.com";
        allow_registration = true;
        registration_token_file = "${config.sops.templates."continuwuity-registration".path}";
      };
    };
  };

  users.users.continuwuity = {
    isSystemUser = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 6167 443 8448 ];
  };

  sops.secrets = {
    "continuwuity/registration-token" = { };
  };

  sops.templates."continuwuity-registration" = {
  content = ''
    ${config.sops.placeholder."continuwuity/registration-token"}
  '';
  path = "/var/lib/private/continuwuity/registration_token";
  owner = "continuwuity";
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/var/lib/private/continuwuity"; user = "continuwuity"; group = "users"; mode = "u=rwx,g=rwx,o=rx"; }
    ];
  };
}