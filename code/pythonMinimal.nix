# vim: set et sw=2 ts=2:
{
  lib,
  packed,
  ...
}: let
  python = packed.python;
in {
  home = {
    packages =
      python.normalPackages
      ++ python.unstablePackages
      ++ [
        # {{{
        (lib.setPrio 200 python)
      ]; # }}}
  };
}
