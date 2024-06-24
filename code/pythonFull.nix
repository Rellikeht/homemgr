# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  lib,
  packed,
  ...
}: let
  python = packed.python;

  normalPackages = with pkgs; [
    # {{{
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
  ]; # }}}
in {
  home = {
    packages =
      # {{{
      normalPackages
      ++ unstablePackages
      ++ python.normalPackages
      ++ python.unstablePackages
      ++ python.addNormalPackages
      ++ python.addUnstablePackages
      ++ [
        # {{{
        (lib.setPrio 300 python)
      ]; # }}}
  }; # }}}
}
