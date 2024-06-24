# vim: set et sw=2 ts=2:
{
  # {{{
  # lib,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  # }}}

  sumPs = ps: lst:
    if lst == []
    then []
    else (b.head lst) ps ++ sumPs ps (b.tail lst);
in {
  inherit sumPs;
}
