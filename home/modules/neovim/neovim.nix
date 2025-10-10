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
            nvim-treesitter.withAllGrammars
        ];
        extraPackages = with pkgs; [
            # LazyVim
            lua-language-server
            nodePackages_latest.vscode-json-languageserver
            nil
            gopls
            gofumpt
            stylua
            # Telescope
            ripgrep
            fd
            fzf
            lazygit
            gcc
            tree-sitter
            # node
        ];
    };
}