# vim: set et sw=2 ts=2:
{
  # {{{
  # pkgs,
  lib,
  dotfiles,
  minimized,
  utils,
  # name,
  ...
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  # }}}
in {
  home = {
    file =
      {
        # {{{
        ".user.bashrc" = {
          # {{{
          source = "${minimized}/.bashrc";
          force = true;
        }; # }}}

        ".user.zshrc" = {
          # {{{
          source = "${dotfiles}/.zshrc";
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
