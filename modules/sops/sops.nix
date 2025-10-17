{ config, ... }:
{

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/persist/home/cmcraft/.config/sops/age/secrets/keys.txt";
  sops.secrets.cmcraft-password.neededForUsers = true;

  sops.secrets.example_key = {
    owner = config.users.users.cmcraft.name;
  };

  users.users.cmcraft = {
    hashedPasswordFile = config.sops.secrets.cmcraft-password.path;
  };
}