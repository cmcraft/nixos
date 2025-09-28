{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # system stuff
    inputs.swww.packages.${pkgs.system}.default
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