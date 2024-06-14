# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  lib,
  dotfiles,
  # name,
  utils,
  ...
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
  # }}}
in {
  home = {
    file =
      {
        # {{{
        ".user.bashrc" = {
          # {{{
          source = "${dots}/.bashrc";
          force = true;
        }; # }}}

        ".user.zshrc" = {
          # {{{
          source = "${dots}/.zshrc";
          force = true;
        }; # }}}
      } # }}}
      // b.listToAttrs (utils.configFiles [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
      ]);
    # }}}

    activation = {
      # {{{
    }; # }}}
  };
}
