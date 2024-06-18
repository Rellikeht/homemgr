# vim: set et sw=2 ts=2:
{
  # {{{
  # config,
  # pkgs,
  # unstable,
  # lib,
  dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
  # }}}
}: let
  # {{{
  # dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";
  # }}}
in {
  home = {
    file =
      {
        # ".config/nvim" = {
        #   # {{{
        #   recursive = true;
        #   source = "${dotfiles}/.config/nvim-server";
        #   force = true;
        # }; # }}}

        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.p10k-shallow.zsh";
          force = true;
        }; # }}}

        ".prompt.bash" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.prompt-shallow.bash";
          force = true;
        }; # }}}
      }
      // b.listToAttrs (utils.configFiles [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
        "nvim"
      ]); # }}}

    activation = {
      # {{{
    }; # }}}

    sessionVariables = {
      # {{{
    }; # }}}
  };
}
