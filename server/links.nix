# vim: set et sw=2 ts=2:
{
  # lib,
  # dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
}: let
  # dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";
  # homeDirectory = "/home/${name}";
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        ])
      // b.listToAttrs (utils.configDirs [
        ])
      // b.listToAttrs (utils.configCDirs [
        "kak"
        "luaformat"
        "yt-dlp"
        "transmission"
        "transmission-daemon"
      ]);
  };
}
