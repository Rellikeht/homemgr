# vim: set et sw=2 ts=2:
{
  # pkgs,
  # unstable,
  # lib,
  # dotfiles,
  # name,
  utils,
  ...
}: let
  b = builtins;
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        ".p10k.zsh"
      ])
      // b.listToAttrs (utils.configDirs [
        ])
      // b.listToAttrs (utils.configCDirs [
        "nvim"
      ]);

    activation = {};
  };
}
