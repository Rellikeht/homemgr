# vim: set et sw=2 ts=2:
{
  # {{{
  config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  stateVersion,
  utils,
  ...
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; [
    # {{{
    dragon-drop
    alacritty
    feh
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
    zathura
  ]; # }}}
in {
  home = {
    file = {
      # {{{
    }; # }}}

    activation = {
      # {{{
    }; # }}}

    sessionVariables = {
      # {{{
    }; # }}}

    packages =
      # {{{
      normalPackages
      ++ unstablePackages;
    # }}}
  };
}
