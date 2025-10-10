{ pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        extraConfig = ''
        '';
        plugins = with pkgs.vimPlugins; [
            LazyVim
        ];
    };
}