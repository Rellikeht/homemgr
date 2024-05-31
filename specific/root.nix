# vim: set et sw=2 ts=2:
{
  # pkgs,
  # unstable,
  # lib,
  dotfiles,
  # name,
  utils,
  ...
}: let
  b = builtins;
in {
  home = {
    file =
      {
        ".p10k.zsh" = {
          recursive = true;
          source = "${dotfiles}/.p10k-root.zsh";
          force = true;
        };
      }
      // b.listToAttrs (utils.configFiles [
        ])
      // b.listToAttrs (utils.configDirs [
        ])
      // b.listToAttrs (utils.configCDirs [
        "nvim"
      ]);

    activation = {};
  };
}
