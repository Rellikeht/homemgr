# vim: set et sw=2 ts=2:
{
  # {{{
  lib,
  dotfiles,
  # name,
  utils,
  ...
  # }}}
}: let
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
  # homeDirectory = "/home/${name}";
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
        # "mpv"
        "qutebrowser"
        "qutebrowsers"
        "youtube-viewer"
        "zathura"

        "vimb"
        "luakit"
        "i3"
        "alacritty"

        "mpv/mpv.conf"
        "mpv/input.conf"
        "mpv/formats"
        "mpv/scripts"
        "mpv/script-opts"
      ]); # }}}

    activation = {
      modifiableFiles =
        # {{{
        dags.entryAfter ["writeBoundary"]
        ''
          cp --update=none ${dots}/.config/mpv/additional.conf "$HOME/.config/mpv/"
          touch "$HOME/.config/mpv/local.conf"
        ''; # }}}
    };
  };
}
