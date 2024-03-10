# vim: set et sw=2 ts=2:
{
  # config,
  # pkgs,
  # unstable,
  lib,
  dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
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
        ".vimrc"
        ".tmux.conf"
        ".guile"

        ".zshrc"
        ".bashrc"
        ".commonrc"
        ".aliasrc"
        ".funcrc"
        ".varrc"
      ])
      // b.listToAttrs (utils.configDirs [
        ".vim"
        ".w3m"
      ])
      // b.listToAttrs (utils.configCDirs [
        "ocaml"
        "vifm"
        "git"
      ]);

    activation = {
      commonBinLinks = dags.entryAfter ["commonBins"] ''
        ln -fs ${dots}/global/bin/* "$HOME/bin/"
      '';
    };
  };
}
