# vim: set et sw=2 ts=2:
{
  pkgs,
  # unstable,
  lib,
  dotfiles,
  # name,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
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
        ".zshrc"

        ".commonrc"
        ".aliasrc"
        ".funcrc"
        ".varrc"
      ])
      // b.listToAttrs (utils.configDirs [
        ".vim"
        ".w3m"
        ".scrs"
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "bpython"
        "ocaml"
        "vifm"
        "git"
        "direnv"
        "fastfetch"
        "glow"
      ]);

    activation = {
      commonBinLinks = dags.entryAfter ["commonBins"] ''
        ln -fs ${dots}/global/bin/* "$HOME/bin/"
        ln -fs ${pkgs.vim}/bin/vim "$HOME/bin/svim"
      '';
      vimUpdate =
        dags.entryAfter ["commonBinLinks"]
        (
          utils.apps.vimUpPrep
          + utils.apps.vimUp ''"$HOME/bin/svim"''
          + utils.apps.vimUp "${pkgs.neovim}/bin/nvim"
        );
    };
  };
}
