{ ... }:
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
  programs.waybar.style = with custom; ''
    * {
      font-family: UbuntuMono Nerd Font Propo;
      font-size: 14px;
      border-radius: 20px;
      margin: 2px;
    }

    window#waybar {
      color: ${selection};
      background-color: rgba(0, 0, 0, 0);
      transition-property: background-color;
      transition-duration: 0.5s;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #window {
      background-color: ${background-darker};
    }

    button:hover {
      background: inherit;
    }

    #custom-launcher {
      color: ${selection};
      background-color: ${background-darker};
    }

    #workspaces button {
      margin: 2 5px;
    }

    #workspaces button.active {
      color: ${cyan};
    }

    #workspaces button.urgent {
      background-color: ${red};
    }

    #workspaces button,
    #cava,
    #clock,
    #custom-playerctl,
    #pulseaudio,
    #network,
    #cpu,
    #custom-dualsense,
    #memory,
    #temperature,
    #disk,
    #tray {
      padding: 0 10px;
      color: ${selection};
      background-color: ${background-darker};
    }

    #temperature.critical {
      color: ${red};
    }

    #pulseaudio.muted {
      color: ${red};
    }

    #network.disconnected {
      color: ${red};
    }

    @keyframes blink {
      to {
        background-color: ${foreground};
        color: ${background-darker};
      }
    }

    #tray>.passive {
      -gtk-icon-effect: dim;
    }

    #tray>.needs-attention {
      -gtk-icon-effect: highlight;
      background-color: ${red};
    }
  '';
}
