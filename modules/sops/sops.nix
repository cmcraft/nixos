{ inputs, config, ... }:
let 
  secretspath = builtins.toString inputs.secrets;
in
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # sops.defaultSopsFile = "${secretspath}/secrets.yaml";
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/persist/home/cmcraft/.config/sops/age/keys.txt";

  sops.secrets = {
    "cmcraft/hf_token" = { owner = "cmcraft"; };
    "cmcraft/password" = {
      neededForUsers = true;
     };
    "cmcraft/private-key" = { };
    "cmcraft/public-key" = { };
  };
}