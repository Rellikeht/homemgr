# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  lib,
  packed,
  ...
}: let
  python = packed.python;
  # TODO remove

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
        (python.pythonFull // {meta.priority = 8;})
      ]; # }}}
  }; # }}}
}
