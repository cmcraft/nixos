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
          title = "Living Room";
          path = "living-room";
          subview = false;
          cards = [
            
          ];
        }
        {
          title = "Master Bedoom";
          path = "master-bedroom";
          subview = false;
          cards = [
            
          ];
        }
        {
          title = "Office";
          path = "office";
          subview = false;
          cards = [
            {
              title = "Office";
              type = "entities";
              entities = [
                {
                  entity = "light.office_fan_1";
                }
                {
                  entity = "light.office_fan_2";
                }
                {
                  entity = "light.office_fan_3";
                }
              ];
            }
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
              type = "button";
              entity = "switch.workbench_relay";
            }
            {
              title = "Utility Room";
              type = "entities";
              entities = [
                {
                  entity = "light.utility_room_front";
                }
                {
                  entity = "light.utility_room_rear";
                }
              ];
            }
          ];
        }
        {
          title = "Lines";
          path = "lines";
          subview = false;
          cards = [

          ];
        }
      ];
    };
  };
}