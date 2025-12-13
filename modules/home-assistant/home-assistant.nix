{ config, pkgs, ... }:
{
  systemd.services.home-assistant.after = [ "zigbee2mqtt.service" ];
  services.home-assistant = {
    enable = true;

    package = pkgs.home-assistant.override {
      extraPackages = ps: with ps; [
        google-auth
        google-auth-oauthlib
        aiohttp
        grpcio
        protobuf
      ];
    };

    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "bluetooth"
      "google_translate"
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
      "google"
      "nest"
      "openweathermap"
      "http"
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
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
      "script ui" = "!include scripts.yaml";
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
            {
              type = "grid";
              square = false;
              cards = [
                {
                  type = "entity";
                  entity = "sensor.basement_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.garage_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.guest_bedroom_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.hallway_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.kitchen_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.master_bedroom_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.office_temperature_temperature";
                }
              ];
            }
            {
              type = "grid";
              square = false;
              cards = [
                {
                  type = "entity";
                  entity = "sensor.basement_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.garage_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.guest_bedroom_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.hallway_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.kitchen_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.master_bedroom_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.office_temperature_humidity";
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
            {
              title = "Living Room Lamp";
              type = "entities";
              entities = [
                {
                  entity = "light.living_room_lamp_1";
                }
              ];
            }
            {
              title = "Living Room Fan";
              type = "entities";
              entities = [
                {
                  entity = "fan.living_room_fan";
                }
                {
                  entity = "light.living_room_fan_1";
                }
                {
                  entity = "light.living_room_fan_2";
                }
              ];
            }
          ];
        }
        {
          title = "Master Bedoom";
          path = "master-bedroom";
          subview = false;
          cards = [
            {
              title = "Master Bedroom";
              type = "entities";
              entities = [
                {
                  entity = "light.master_bedroom_fan_1";
                }
                {
                  entity = "light.master_bedroom_fan_2";
                }
                {
                  entity = "light.master_bedroom_fan_3";
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
            {
              title = "Temperatures";
              type = "statistics-graph";
              period = "hour";
              chartType = "line";
              statTypes = [
                "mean"
              ];
              hideLegend = true;
              daysToShow = 7;
              entities = [
                {
                  type = "entity";
                  entity = "sensor.basement_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.garage_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.guest_bedroom_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.hallway_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.kitchen_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.master_bedroom_temperature_temperature";
                }
                {
                  type = "entity";
                  entity = "sensor.office_temperature_temperature";
                }
              ];
            }
            {
              title = "Humidity";
              type = "statistics-graph";
              period = "hour";
              chartType = "line";
              statTypes = [
                "mean"
              ];
              hideLegend = true;
              daysToShow = 7;
              entities = [
                {
                  type = "entity";
                  entity = "sensor.basement_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.garage_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.guest_bedroom_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.hallway_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.kitchen_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.master_bedroom_temperature_humidity";
                }
                {
                  type = "entity";
                  entity = "sensor.office_temperature_humidity";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}