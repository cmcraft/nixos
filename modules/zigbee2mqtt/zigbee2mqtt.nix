{ config, ... }:
{
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = {
        enabled = config.services.home-assistant.enable;
        discoveryTopic = "homeassistant";
        statusTopic = "homeassistant/status";
      };
      permit_join = true;
      # EFR32MG24 
      #serial = {
      #  port = "tcp://192.168.1.200:6638";
      #  baudrate = "115200";
      #  adapter = "ember";
      #  disableLed = "false";
      #  advanced = {
      #    transmitPower = "20";
      #  };  
      #};
      # CC2674P10
      serial = {
        port = "tcp://192.168.1.200:7638";
        baudrate = 115200;
        adapter = "zstack";
        disableLed = "false";
        advanced = {
          transmitPower = "20";
        };  
      };
      mqtt = {
        server = "!secrets.yaml server";
        baseTopic = "zigbee2mqtt";
        clientId = "zigbee2mqtt";
        user = "!secrets.yaml user";
        password = "'!secrets.yaml password'";
        keepalive = 60;
        clean = true;
        retain = false;
        qos = 0;
      };
      frontend = {
        enabled = true;
        port = 8124;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8124 7638 6638 ];
  };  
}