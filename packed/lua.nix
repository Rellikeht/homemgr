# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
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
      magick
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
      # }}}
    ];

  sumPs = ps: lst:
    if lst == []
    then []
    else (b.head lst) ps ++ sumPs ps (b.tail lst);
in rec {
  inherit luaMinimalPkgs luaNormalPkgs luaUnstablePkgs;
  inherit luaCommonPkgs luaPkgs luajitPkgs;

  luaNop =
    luaProv.withPackages
    (ps: sumPs ps [luaCommonPkgs luaPkgs]);

  luajitNop =
    luajitProv.withPackages
    (ps: sumPs ps [luaCommonPkgs luajitPkgs]);

  # lua = lib.setPrio 150 luaNop;
  # luajit = lib.setPrio 100 luajitNop;
}
