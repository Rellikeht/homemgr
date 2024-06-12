# vim: set et sw=2 ts=2:
{
  config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;

  normalPackages = with pkgs; [
    # {{{
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
  ]; # }}}

  dots = "${dotfiles}";
in {
  home = {
    file = {};

    activation = {};

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
