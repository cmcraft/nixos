{ config, lib, pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    windowrulesv2 = [
      # browser tags
      "tag +browser, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$"
      "tag +browser, class:^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
      "tag +browser, class:^(chrome-.+-Default)$" # Chrome PWAs
      "tag +browser, class:^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$"
      "tag +browser, class:^(Brave-browser(-beta|-dev|-unstable)?)$"
      "tag +browser, class:^([Tt]horium-browser|[Cc]achy-browser)$"
      "tag +browser, class:^(zen-alpha|zen)$"
      "tag +browser, class:^([Bb]itwarden)$"

      #im tags
      "tag +im, class:^([Ww]ebcord)$"
      "tag +im, class:^([Dd]iscord(-[Cc]anary)?)$"
      
      # terminals
      "tag +terminal, class:^(Alacritty|kitty|kitty-dropterm)$"
      
      # project tags
      "tag +projects, class:^(codium|codium-url-handler|VSCodium)$"
      "tag +projects, class:^(VSCode|code-url-handler)$"
      "tag +projects, class:^(jetbrains-.+)$" # JetBrains IDEs

      # game tags
      "tag +games, class:^(gamescope)$"
      "tag +games, class:^(steam_app_\d+)$"

      #gamestore
      "tag +gamestore, class:^([Ss]team(-native)?)$"
      "tag +gamestore, class:^([Hh]eroic)$"
      "tag +gamestore, class:^([Ll]utris)$"
      "tag +gamestore, class:^([Bb]ottles)$"

      # multimedia tags
      "tag +multimedia, class:^([Aa]udacious)$"
      "tag +multimedia_video, class:^([Mm]pv|vlc)$"

      # settings tags
      "tag +settings, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
      "tag +settings, class:^(qt5ct|qt6ct|[Yy]ad)$"

      # windowrule move to workspace
			"workspace 1, tag:projects*"
      "workspace 1, tag:terminal*"
			"workspace 2, tag:browser*"
      "workspace 2, tag:gamestore*"
      "workspace 3, tag:games*"
			"workspace 4, tag:im*"
      "workspace 5, tag:settings*"
    ];
  };
}