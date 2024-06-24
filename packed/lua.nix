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
  # {{{
  b = builtins;
  u = putils;
  # }}}

  # {{{
  luaProv = pkgs.lua5_4;
  luajitProv = pkgs.luajit;
  # }}}

  luaMinimalPkgs = with pkgs; [
    # {{{
    luaformatter
  ]; # }}}

  luaNormalPkgs = with pkgs; [
    # {{{
    lua-language-server
  ]; # }}}

  luaUnstablePkgs = with unstable; [
    # {{{
  ]; # }}}

  luaCommonPkgs = ps:
    with ps; [
      # {{{
      luacheck
      luafilesystem
      sqlite
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
in rec {
  inherit luaMinimalPkgs luaNormalPkgs luaUnstablePkgs;
  inherit luaCommonPkgs luaPkgs luajitPkgs;
  inherit luaAddCommonPkgs luaAddPkgs luajitAddPkgs;

  lua =
    luaProv.withPackages
    (ps:
      u.sumPs ps [
        # {{{
        luaCommonPkgs
        luaPkgs
      ]); # }}}

  luajit =
    luajitProv.withPackages
    (ps:
      u.sumPs ps [
        # {{{
        luaCommonPkgs
        luajitPkgs
      ]); # }}}

  luaAdd =
    luaProv.withPackages
    (ps:
      u.sumPs ps [
        # {{{
        luaCommonPkgs
        luaPkgs
        luaAddCommonPkgs
        luaAddPkgs
      ]); # }}}

  luajitAdd =
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
