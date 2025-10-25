{ config, ... }:
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      # "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
    extraPackages = python3Packages: with python3Packages; [
    # keep in case we need it later
  ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
    openFirewall = true;
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant.enabled = config.services.home-assistant.enable;
      permit_join = true;
    };
  };
}