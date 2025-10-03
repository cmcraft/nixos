{ pkgs, ... }:
{
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        # gamescopeSession.enable = true;
        package = pkgs.steam.override {
            extraPkgs = pkgs': with pkgs'; [
                xorg.libXcursor
                xorg.libXi
                xorg.libXinerama
                xorg.libXScrnSaver
                libpng
                libpulseaudio
                libvorbis
                stdenv.cc.cc.lib # Provides libstdc++.so.6
                libkrb5
                keyutils
                # Add other libraries as needed
            ];
        };
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
    };
    # hardware.steam-hardware.enable = true;
}