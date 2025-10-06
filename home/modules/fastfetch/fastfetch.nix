{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "builtin";
        source = "nixos";
        color = {
          "1" = "cyan";
          "2" = "blue";
        };
        padding = {
          right = 3;
        };
      };
      display = {
        size = {
          maxPrefix = "GB";
          binaryPrefix = "iec";
          ndigits = 2;
        };
        percent = {
          type = [
            "num" "bar" "num-color"
          ];
          green = "50";
          yellow = "80";
        };
        bar = {
          width = 15;
          char = {
            elapsed = "-";
            total = "-";
          };
        };
        temp = {
          unit = "C";
          green = 60;
          yellow = 80;
        };
        color = {
          keys = "cyan";
          title = "blue";
        };
        separator = " -> ";
      };
      modules = [
        {
          type = "title";
          format = "{user-name}@{host-name}";
        }
        "separator"
        {
          type = "os";
          key = "OS";
          format = "{name} {version}";
        }
        {
          type = "kernel";
          format = "{release}";
        }
        {
          type = "cpu";
          key = "CPU";
          format = "{name} ({cores}) @ {freq-max}";
        }
        {
          type = "gpu"; 
          format = "{vendor} {name}";
          temp = {
            green = 65;
            yellow = 85;
          };
        }
        {
          type = "memory"; 
          format =  "{used} / {total}";
          percent = {
            type = [
              "num" 
              "bar"
            ];
          };
        }
        {
          type = "disk"; 
          folders = "/";
          format = "{size-used} / {size-total}";
        }
        {
          type = "datetime";
          key = "Date";
          format = "{1}-{3}-{11}";
        }
        {
          type = "datetime";
          key = "Time";
          format = "{14}:{17}:{20}";
        }
        "break"
        "player"
        "media"
      ];
    };
  };
}