# vim: set et sw=2 ts=2:
{
  pkgs,
  lib,
  dotfiles,
  # name,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        # {{{
        ".user.bashrc"
        ".user.zshrc"
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
