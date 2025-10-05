{ config, lib, pkgs, inputs, ... }:
let
  custom = {
    background-darker = "rgba(30, 31, 41, 230)";
    background = "#282a36";
    selection = "#44475a";
    foreground = "#f8f8f2";
    comment = "#6272a4";
    cyan = "#8be9fd";
    green = "#50fa7b";
    orange = "#ffb86c";
    pink = "#ff79c6";
    purple = "#bd93f9";
    red = "#ff5555";
    yellow = "#f1fa8c";

    purple-background = "#201030";
  };
in
{
  imports = [
    ./waybar-style.nix
  ];

  programs.waybar.enable = true;
  programs.waybar.settings.mainbar = with custom; {
        layer = "top";
        position = "top";
        height = 45;
        modules-left = [  
          "custom/launcher"
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
         ];
        modules-right = [
          "tray" 
          "cpu"
          "memory"
          "disk"
          "pulseaudio"
          "network" 
          "clock"
        ];
        clock = {
      calendar = {
        format = {
          today = "<span color='#98971A'><b>{}</b></span>";
        };
      };
      format = "  {:%H:%M} ";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "  {:%d/%m} ";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "10" = "10";
        active = "";
        sort-by-number = true;
      };
      persistent-workspaces = {
        "1" = [ ];
        "2" = [ ];
        "3" = [ ];
        "4" = [ ];
        "5" = [ ];
      };
    };
    cpu = {
      format = "<span foreground='${selection}'> </span> {usage}%";
      format-alt = "<span foreground='${selection}'> </span> {avg_frequency} GHz";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] alacritty --override font_size=14 --title float_alacritty -e btop'";
    };
    memory = {
      format = "<span foreground='${selection}'>󰟜 </span>{}%";
      format-alt = "<span foreground='${selection}'>󰟜 </span>{used} GiB"; # 
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] alacritty --override font_size=14 --title float_alacritty -e btop'";
    };
    disk = {
      # path = "/";
      format = "<span foreground='${selection}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] alacritty --override font_size=14 --title float_alacritty -e btop'";
    };
    network = {
      format-wifi = "<span foreground='${selection}'> </span> {signalStrength}%";
      format-ethernet = "<span foreground='${selection}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "<span foreground='${red}'>󰖪 </span>";
    };
    tray = {
      format = " 󱊖 ";
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='${red}'> </span> {volume}%";
      format-icons = {
        default = [ "<span foreground='${selection}'> </span>" ];
      };
      scroll-step = 2;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
    };
    "custom/launcher" = {
      format = "  ";
      on-click = "wpaperctl next";
      on-click-right = "rofi -show drun -show-icons";
      tooltip = "true";
      tooltip-format = "Random Wallpaper";
    };
        };
}