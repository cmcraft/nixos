{ config, lib, pkgs, ... }:
{
    wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      [
        "SUPER, Q, killactive,"
        "$mod, RETURN, exec, alacritty"
        
        "$mod, A, exec, rofi -show drun -show-icons"
        "ALT, Tab, exec, rofi -show window"

        "$mod, B, exec, zen"

        ", Print, exec, grimblast --notify copysave area"
        "SHIFT, Print, exec, grimblast --notify copysave active"
        "CTRL, Print, exec, grimblast --notify copysave screen"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    };  
}