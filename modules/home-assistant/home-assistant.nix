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
      "mqtt"
      "mqtt_eventstream"
      "mqtt_json"
      "mqtt_room"
      "mqtt_statestream"
      "myq"
      "nest"
      "openweathermap"
      "climate"
      "camera"
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
    lovelaceConfigWritable = true;
    lovelaceConfig = {
      title = "Zoraya";
      views = [
        {
          title = "Zoraya";
          cards = [
            {
              type = "weather-forecast";
              entity = "weather.openweathermap";
              showCurrent = true;
              showForecast = true;
              forecastType = "legacy";
            }
            {
              type = "picture-entity";
              entity = "camera.front_door";
            }
            {
              type = "thermostat";
              entity = "climate.hallway";
              name = "Hallway";
              features = [
                {
                  type = "climate-fan-modes";
                  style = "dropdown";
                }
                {
                  type = "climate-hvac-modes";
                }
              ];
            }
          ];
        }
        {
          title = "Office";
          path = "office";
          subview = false;
          cards = [
            {
              title = "Desk";
              type = "entities";
              entities = [
                {
                  entity = "light.office_desk_left";
                }
                {
                  entity = "light.office_desk_right";
                }
              ];
            }
          ];
        }
        {
          title = "Utility Room";
          path = "utility-room";
          subview = false;
          cards = [
            {
              title = "Workbench";
              type = "switch";
              entity = "switch.workbench_relay";
            }
          ];
        }
      ];
    };
  };
}