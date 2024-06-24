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
  luaProv = pkgs.lua54;
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
in rec {
  inherit luaMinimalPkgs luaNormalPkgs luaUnstablePkgs;
  inherit luaCommonPkgs luaPkgs luajitPkgs;

  luaNop =
    luaProv.withPackages
    (luaCommonPkgs ++ luaPkgs);

  luajitNop =
    luajitProv.withPackages
    (luaCommonPkgs ++ luaPkgs);

  lua = lib.setPrio 150 luaNop;
  luajit = lib.setPrio 100 luajitNop;
}
