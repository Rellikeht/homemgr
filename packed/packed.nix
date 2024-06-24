{
  # {{{
  pkgs,
  unstable,
  lib,
  ...
  # }}}
} @ inputs: let
  # {{{
  b = builtins;
  # }}}

  # {{{
  putils = import ./utils.nix {inherit lib;};
  args = inputs // {inherit putils;};
  # }}}

  # {{{
  lua = import ./lua.nix args;
  python = import ./python.nix args;
  # guile = import ./guile.nix inputs;
  # }}}
in {
  # {{{
  inherit lua python;
  # }}}
}
