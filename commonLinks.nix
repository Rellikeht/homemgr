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
        ".p10k.zsh"
        ".bashrc"
        ".zshrc"
        ".p10k.zsh"

        ".commonrc"
        ".aliasrc"
        ".funcrc"
        ".varrc"
      ])
      // b.listToAttrs (utils.configDirs [
        ".vim"
        ".w3m"
        ".scrs"
      ])
      // (
        let
          cdirs = b.listToAttrs (utils.configCDirs [
            "nvim"
            "ocaml"
            "vifm"
            "git"
            "direnv"
            "fastfetch"
            "glow"
          ]);
        in
          cdirs
      );

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
