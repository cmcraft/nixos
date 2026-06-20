{ config, pkgs, inputs, ... }:
{
  services.matrix-continuwuity = {
    enable = true;
    package = inputs.continuwuity.packages.${pkgs.stdenv.hostPlatform.system}.default;
    admin.enable = true;
    settings = {
      global = {
        server_name = "knit-purl-binary.com";
        database_path = "/var/lib/continuwuity";
        allow_registration = true;
        registration_token_file = "${config.sops.templates."continuwuity-registration".path}";
      };
    };
  };

  users.users.continuwuity = {
    isSystemUser = true;
  };

  sops.secrets = {
    "continuwuity/registration-token" = { };
  };

  sops.templates."continuwuity-registration" = {
  content = ''
    ${config.sops.placeholder."continuwuity/registration-token"}
  '';
  path = "/var/lib/continuwuity/registration_token";
  owner = "continuwuity";
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/var/lib/continuwuity"; user = "continuwuity"; group = "users"; mode = "u=rwx,g=rwx,o=rx"; }
    ];
  };
}