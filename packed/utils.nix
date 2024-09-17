# vim: set et sw=2 ts=2:
{
  # {{{
  lib,
  ...
  # }}}
}: let
  # {{{
  # b = builtins;
  # }}}
  sumPs = ps: lst:
    if lst == []
    then []
    else (lib.head lst) ps ++ sumPs ps (lib.tail lst);
in {
  inherit sumPs;
}
