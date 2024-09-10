# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  putils,
  ...
  # }}}
}: let
  #  {{{ helpers
  # {{{
  b = builtins;
  u = putils;
  # }}}

  # wrapper {{{

  repSym = c:
    if (c == "+" || c == "-" || c == "." || c == "_")
    then ""
    else c;

  luaWrapper = pkg: let
    name =
      lib.concatStrings
      (map repSym (lib.stringToCharacters pkg.lua.luaAttr));
  in
    pkgs.writeScriptBin name ''
      exec ${pkg}/bin/lua $@
    '';

  #  }}}

  #  }}}

  # package sets {{{

  # {{{
  luaProv = pkgs.lua5_4;
  luajitProv = pkgs.luajit;
  # }}}

  luaMinPkgs = with pkgs; [
    # {{{
    luaformatter
  ]; # }}}

  luaNormalPkgs = with pkgs; [
    # {{{
    lua-language-server
  ]; # }}}

  luaMinUnstablePkgs = with unstable; [
    # {{{
  ]; # }}}

  luaUnstablePkgs = with unstable; [
    # {{{
  ]; # }}}

  luaCommonPkgs = ps:
    with ps; [
      # {{{
      luacheck
      luafilesystem
      luautf8
      # }}}
    ];

  luaPkgs = ps:
    with ps; [
      # {{{
      # }}}
    ];

  luajitPkgs = ps:
    with ps; [
      # {{{
      magick
      # }}}
    ];

  luaAddCommonPkgs = ps:
    with ps; [
      # {{{
      # }}}
    ];

  luaAddPkgs = ps:
    with ps; [
      # {{{
      # }}}
    ];

  luajitAddPkgs = ps:
    with ps; [
      # {{{
      # }}}
    ];
  #  }}}
in rec {
  #  {{{
  inherit luaMinPkgs luaMinUnstablePkgs;
  inherit luaNormalPkgs luaUnstablePkgs;
  inherit luaCommonPkgs luaPkgs luajitPkgs;
  inherit luaAddCommonPkgs luaAddPkgs luajitAddPkgs;
  inherit luaWrapper;
  #  }}}

  luaP =
    luaProv.withPackages
    (ps:
      u.sumPs ps [
        # {{{
        luaCommonPkgs
        luaPkgs
      ]); # }}}

  luajitP =
    luajitProv.withPackages
    (ps:
      u.sumPs ps [
        # {{{
        luaCommonPkgs
        luajitPkgs
      ]); # }}}

  luaAddP =
    luaProv.withPackages
    (ps:
      u.sumPs ps [
        # {{{
        luaCommonPkgs
        luaPkgs
        luaAddCommonPkgs
        luaAddPkgs
      ]); # }}}

  luajitAddP =
    luajitProv.withPackages
    (ps:
      u.sumPs ps [
        # {{{
        luaCommonPkgs
        luajitPkgs
        luaAddCommonPkgs
        luajitAddPkgs
      ]); # }}}
}
