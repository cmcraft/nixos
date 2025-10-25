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
    "cmcraft/password" = {
      neededForUsers = true;
     };
    "cmcraft/private-key" = { };
    "cmcraft/public-key" = { };
    "factorio/password" = { };
    "factorio/token" = { };
    "mosquitto/password" = {};
    "redbot/token" = { };
    "cloudflare/zone-identifier" = { };
    "cloudflare/token" = { };
    "terraria/password" = { };
  };

  sops.templates."terraria".content = ''
    {
      "journeypermission_time_setmidnight" : "2",
      "journeypermission_rain_setfrozen" : "2",
      "journeypermission_godmode" : "2",
      "port" : "7777",
      "password" : "${config.sops.placeholder."terraria/password"}",
      "journeypermission_setspawnrate" : "2",
      "journeypermission_time_setdusk" : "2",
      "journeypermission_rain_setstrength" : "2",
      "journeypermission_biomespread_setfrozen" : "2",
      "banlist" : "banlist.txt",
      "upnp" : "0",
      "journeypermission_time_setnoon" : "2",
      "priority" : "1",
      "secure" : "0",
      "journeypermission_time_setspeed" : "2",
      "npcstream" : "15",
      "maxplayers" : "8",
      "journeypermission_time_setfrozen" : "2",
      "journeypermission_time_setdawn" : "2",
      "motd" : "Wizards Unite!",
      "language" : "en-US",
      "journeypermission_wind_setfrozen" : "2",
      "difficulty" : "1",
      "autocreate" : "2",
      "journeypermission_setdifficulty" : "2",
      "journeypermission_wind_setstrength" : "2",
      "journeypermission_increaseplacementrange" : "2"
    }
  '';
  sops.templates."redbot".content = ''${config.sops.placeholder."redbot/token"}'';

  sops.templates."factorio/server-settings".content = ''
    {
      "name" : "Constantine's Rimworld",
      "description" : "Constantine's Crazy Cosmonauts!",
      "tags": [ "game", "tags" ],

      "_comment_max_players": "Maximum number of players allowed, admins can join even a full server. 0 means unlimited.",
      "max_players": 0,

      "_comment_visibility": [
        "public: Game will be published on the official Factorio matching server",
        "lan: Game will be broadcast on LAN"
      ],
      "visibility": {
        "public": true,
        "lan": true
      },

      "_comment_credentials": "Your factorio.com login credentials. Required for games with visibility public",
      "username" : "cmcraft",
      "_comment_password": "",

      "_comment_token": "Authentication token. May be used instead of 'password' above.",
      "token" : "${config.sops.placeholder."factorio/token"}",

      "game-password" : "${config.sops.placeholder."factorio/password"}",

      "_comment_require_user_verification": "When set to true, the server will only allow clients that have a valid Factorio.com account",
      "require_user_verification": true,

      "_comment_max_upload_in_kilobytes_per_second": "optional, default value is 0. 0 means unlimited.",
      "max_upload_in_kilobytes_per_second": 0,

      "_comment_max_upload_slots": "optional, default value is 5. 0 means unlimited.",
      "max_upload_slots": 5,

      "_comment_minimum_latency_in_ticks": "optional one tick is 16ms in default speed, default value is 0. 0 means no minimum.",
      "minimum_latency_in_ticks": 0,

      "_comment_max_heartbeats_per_second": "Network tick rate. Maximum rate game updates packets are sent at before bundling them together. Minimum value is 6, maximum value is 240.",
      "max_heartbeats_per_second": 60,

      "_comment_ignore_player_limit_for_returning_players": "Players that played on this map already can join even when the max player limit was reached.",
      "ignore_player_limit_for_returning_players": false,

      "_comment_allow_commands": "possible values are, true, false and admins-only",
      "allow_commands": "admins-only",

      "_comment_autosave_interval": "Autosave interval in minutes",
      "autosave_interval": 10,

      "_comment_autosave_slots": "server autosave slots, it is cycled through when the server autosaves.",
      "autosave_slots": 5,

      "_comment_afk_autokick_interval": "How many minutes until someone is kicked when doing nothing, 0 for never.",
      "afk_autokick_interval": 0,

      "_comment_auto_pause": "Whether should the server be paused when no players are present.",
      "auto_pause": true,

      "_comment_auto_pause_when_players_connect": "Whether should the server be paused when someone is connecting to the server.",
      "auto_pause_when_players_connect": false,

      "only_admins_can_pause_the_game": true,

      "_comment_autosave_only_on_server": "Whether autosaves should be saved only on server or also on all connected clients. Default is true.",
      "autosave_only_on_server": true,

      "_comment_non_blocking_saving": "Highly experimental feature, enable only at your own risk of losing your saves. On UNIX systems, server will fork itself to create an autosave. Autosaving on connected Windows clients will be disabled regardless of autosave_only_on_server option.",
      "non_blocking_saving": false,

      "_comment_segment_sizes": "Long network messages are split into segments that are sent over multiple ticks. Their size depends on the number of peers currently connected. Increasing the segment size will increase upload bandwidth requirement for the server and download bandwidth requirement for clients. This setting only affects server outbound messages. Changing these settings can have a negative impact on connection stability for some clients.",
      "minimum_segment_size": 25,
      "minimum_segment_size_peer_count": 20,
      "maximum_segment_size": 100,
      "maximum_segment_size_peer_count": 10
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