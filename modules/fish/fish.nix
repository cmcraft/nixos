{ config, ... }:
{
  programs.fish = {
    enable = true;

    shellInit = ''
      if test -f "${config.sops.secrets.hf_token.path}"
        set -gx HF_TOKEN (cat "${config.sops.secrets.hf_token.path}")
      end

      fastfetch
    '';
  };
}