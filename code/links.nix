# vim: set et sw=2 ts=2:
{utils, ...}: let
  b = builtins;
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        # {{{
      ])
      # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ])
      # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
        "nim"
        "kak"

        "ruff"
        "clangd"
        "luaformat"
        "yamlfmt"
        "typstfmt"
      ]); # }}}
  };
}
