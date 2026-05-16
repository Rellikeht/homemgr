# vim: set et sw=2 ts=2:
{
  # {{{
  # config,
  # pkgs,
  # unstable,
  # lib,
  dotfiles,
  minimized,
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
        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/p10ks/shallow.zsh";
          force = true;
        }; # }}}

        ".config/nvim" = {
          # {{{
          recursive = true;
          source = "${minimized}/.config/nvim";
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
      ]); # }}}

    activation = {
      # {{{
    }; # }}}

    sessionVariables = {
      # {{{
    }; # }}}
  };
}
