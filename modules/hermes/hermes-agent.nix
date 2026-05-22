# configuration.nix
{ config, ... }: {
  services.hermes-agent = {
    enable = true;
    settings.model.base_url = "http://127.0.0.1:13305/v1";
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };
}