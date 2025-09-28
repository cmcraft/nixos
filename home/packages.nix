{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    swww
    waybar
    
    #gaming stuff
    steam
    steam-gamescope
    mangohud 
    protonup-qt 
    lutris 
    bottles 
    heroic
    #
  ];
}