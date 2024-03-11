# vim: set et sw=2 ts=2:
{
  # config,
  # pkgs,
  # unstable,
  lib,
  # dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  # b = builtins;
  # dots = "${dotfiles}";
  # homeDirectory = "/home/${name}";
in {
  home = {
    file = {};

    # TODO dotfile links
    activation = {
      gitLinks = dags.entryAfter ["gits"] (
        (utils.makeDotsLinks ''"$HOME"'' [])
        + (utils.makeDotsLinks ''"$HOME/.config"'' [])
        + (utils.makeDotsLinks ''"$HOME/bin"'' [])
        + ''''
      );
    };

    sessionVariables = {};
  };
}
