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
      homeassistant = {
        enabled = config.services.home-assistant.enable;
        discoveryTopic = "homeassistant";
      };
      permit_join = true;
      # 
      #serial = {
      #  port = "tcp://192.168.1.200:6638";
      #  baudrate = "115200";
      #  adapter = "ember";
      #  disableLed = "false";
      #  advanced = {
      #    transmitPower = "20";
      #  };  
      #};
      # CC2674P10 -- Zigbee
      serial = {
        port = "tcp://192.168.1.200:7638";
        baudrate = "115200";
        adapter = "zstack";
        disableLed = "false";
        advanced = {
          transmitPower = "20";
        };  
      };
      mqtt = {
        server = "mqtt://localhost:1883";
        baseTopic = "zigbee2mqtt";
        user = "cmcraft";
        password = "${sops.templates."mosquitto".content}";
      };
    };
  };
}