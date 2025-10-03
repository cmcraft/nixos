{ config, lib, pkgs, inputs, ... }:
let
  custom = {
    font = "Maple Mono";
    font_size = "18px";
    font_weight = "bold";
    text_color = "#FBF1C7";
    background_0 = "#1D2021";
    background_1 = "#282828";
    border_color = "#928374";
    red = "#CC241D";
    green = "#98971A";
    yellow = "#FABD2F";
    blue = "#458588";
    magenta = "#B16286";
    cyan = "#689D6A";
    orange = "#D65D0E";
    opacity = "1";
    indicator_height = "2px";
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
        height = 30;
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
      format = "  {:%H:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "  {:%d/%m}";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "I";
        "2" = "II";
        "3" = "III";
        "4" = "IV";
        "5" = "V";
        "6" = "VI";
        "7" = "VII";
        "8" = "VIII";
        "9" = "IX";
        "10" = "X";
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
      format = "<span foreground='${green}'> </span> {usage}%";
      format-alt = "<span foreground='${green}'> </span> {avg_frequency} GHz";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] alacritty --override font_size=14 --title float_alacritty btop'";
    };
    memory = {
      format = "<span foreground='${cyan}'>󰟜 </span>{}%";
      format-alt = "<span foreground='${cyan}'>󰟜 </span>{used} GiB"; # 
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] alacritty --override font_size=14 --title float_alacritty btop'";
    };
    disk = {
      # path = "/";
      format = "<span foreground='${orange}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] alacritty --override font_size=14 --title float_alacritty btop'";
    };
    network = {
      format-wifi = "<span foreground='${magenta}'> </span> {signalStrength}%";
      format-ethernet = "<span foreground='${magenta}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "<span foreground='${magenta}'>󰖪 </span>";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='${blue}'> </span> {volume}%";
      format-icons = {
        default = [ "<span foreground='${blue}'> </span>" ];
      };
      scroll-step = 2;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
    };
    "custom/launcher" = {
      format = "";
      on-click = "wpaperctl next";
      on-click-right = "rofi -show drun -show-icons";
      tooltip = "true";
      tooltip-format = "Random Wallpaper";
    };
        };
}