# vim: set et sw=2 ts=2:
{
  # {{{
  # lib,
  # dotfiles,
  # name,
  utils,
  ...
  # }}}
}: let
  b = builtins;
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
        "kak"
        "luaformat"
        "yt-dlp"
        "transmission"
        "transmission-daemon"
      ]); # }}}
  };
}
