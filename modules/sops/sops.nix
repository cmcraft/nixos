{ inputs, config, ... }:
let 
  secretspath = builtins.toString inputs.secrets;
in
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # sops.defaultSopsFile = "${secretspath}/secrets.yaml";
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

  sops.templates."terraria".content = ''
    ${config.sops.placeholder."terraria/password"}
  '';

  sops.templates."factorio/extraSettingsFile".content = ''
    {
      "game-password" : "${config.sops.placeholder."factorio/password"}",
      "token" : "${config.sops.placeholder."factorio/token"}"
    }
  '';

  sops.templates."ddns-updater/config".content = ''
    {
      "settings": [
        {
          "provider": "cloudflare",
          "zone_identifier": "${config.sops.placeholder."cloudflare/zone-identifier"}",
          "domain": "knit-purl-binary.com",
          "ttl": 600,
          "ip_version": "ipv4",
          "token": "${config.sops.placeholder."cloudflare/token"}",
          "proxied": true
        }
      ]
  '';
}