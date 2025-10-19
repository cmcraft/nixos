{ config, ... }:
{

  sops.defaultSopsFile = "/persist/etc/nixos/secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/persist/home/cmcraft/.config/sops/age/secrets/keys.txt";

  sops.secrets = {
    "cmcraft/password" = {
      neededForUsers = true;
     };
    "cmcraft/private-key" = { };
    "cmcraft/public-key" = { };
    "factorio/password" = { };
    "factorio/token" = { };
    "redbot/token" = { };
    "cloudflare/zone-identifier" = { };
    "cloudflare/token" = { };
    "terraria/password" = { };
  };

  users.users.cmcraft = {
    hashedPasswordFile = config.sops.secrets."cmcraft/password";
  };
}