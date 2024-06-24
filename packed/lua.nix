# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  luaProv,
  luajitProv,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  dags = lib.hm.dag;
  # }}}

  luaNormalPkgs = with pkgs; [
    # {{{
    lua-language-server
    luaformatter
  ]; # }}}

  luaUnstablePkgs = with unstable; [
    # {{{
  ]; # }}}

  luaDefCommonPkgs = ps:
    with ps; [
      # {{{
      luacheck
      magick
      # }}}
    ];

  luaDefPkgs = ps:
    with ps; [
      # {{{
      # }}}
    ];

  luajitDefPkgs = ps:
    with ps; [
      # {{{
      # }}}
    ];
in rec {
  inherit luaNormalPkgs luaUnstablePkgs;
  inherit luaDefCommonPkgs luaDefPkgs luajitDefPkgs;

  defLuaNop =
    luaProv.withPackages
    (luaDefCommonPkgs ++ luaDefPkgs);

  defLuajitNop =
    luajitProv.withPackages
    (luaDefCommonPkgs ++ luajitDefPkgs);

  defLua = lib.setPrio 150 defLuaNop;
  defLuajit = lib.setPrio 100 defLuajitNop;
}
