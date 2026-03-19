{ config, lib, pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # browser tags
      "tag +browser, match:class ^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$"
      "tag +browser, match:class ^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
      "tag +browser, match:class ^(chrome-.+-Default)$" # Chrome PWAs
      "tag +browser, match:class ^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$"
      "tag +browser, match:class ^(Brave-browser(-beta|-dev|-unstable)?)$"
      "tag +browser, match:class ^([Tt]horium-browser|[Cc]achy-browser)$"
      "tag +browser, match:class ^(zen-alpha|zen)$"
      "tag +browser, match:class ^([Bb]itwarden)$"

      #im tags
      "tag +im, match:class ^([Ww]eb[Cc]ord)$"
      "tag +im, match:class ^([Dd]iscord(-[Cc]anary)?)$"
      
      # terminals
      "tag +terminal, match:class ^(Alacritty|kitty|kitty-dropterm)$"
      
      # project tags
      "tag +projects, match:class ^(codium|codium-url-handler|VSCodium)$"
      "tag +projects, match:class ^(VSCode|code-url-handler)$"
      "tag +projects, match:class ^([Cc]ode)$"
      "tag +projects, match:class ^(jetbrains-.+)$" # JetBrains IDEs

      # game tags
      "tag +games, match:class ^(gamescope)$"
      "tag +games, match:class ^(steam_app_\d+)$"

      #gamestore
      "tag +gamestore, match:class ^([Ss]team(-native)?)$"
      "tag +gamestore, match:class ^([Hh]eroic)$"
      "tag +gamestore, match:class ^(net.lutris.[Ll]utris)$"
      "tag +gamestore, match:class ^(com.usebottles.[Bb]ottles)$"

      # multimedia tags
      "tag +multimedia, match:class ^([Aa]udacious)$"
      "tag +multimedia_video, match:class ^([Mm]pv|vlc)$"

      # settings tags
      "tag +settings, match:class ^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
      "tag +settings, match:class ^(qt5ct|qt6ct|[Yy]ad)$"

      # windowrule move to workspace
			"workspace 1, match:tag projects*"
      "workspace 1, match:tag terminal*"
      "workspace 2, match:tag gamestore*"
      "workspace 3, match:tag games*"
      "workspace 4, match:tag browser*"
			"workspace 4, match:tag im*"
      "workspace 5, match:tag settings*"
    ];
  };
}