# vim: set et sw=2 ts=2:
{
  #  {{{
  # config,
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  stateVersion,
  utils,
  ...
  #  }}}
}: let
  dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";

  normalPackages = with pkgs; [
    #  {{{
    onefetch
    libcaca
    aalib
    (plan9port // {meta.priority = 6;})
    # typst-live
  ]; #  }}}

  unstablePackages = with unstable; [
    #  {{{
  ]; #  }}}
  # homeDirectory = "/home/${name}";
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configCDirs [
        ]);

    activation = {};

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
