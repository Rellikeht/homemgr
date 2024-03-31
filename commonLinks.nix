# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
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
  # stow = "${pkgs.stow}/bin/stow";
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
        ".commonrc"
        ".aliasrc"
        ".funcrc"
        ".varrc"
      ])
      // b.listToAttrs (utils.configDirs [
        ".vim"
        ".w3m"
      ])
      // (
        let
          cdirs = b.listToAttrs (utils.configCDirs [
            "nvim"
            "ocaml"
            "vifm"
            "git"
            "direnv"
          ]);
        in
          cdirs
        # b.trace cdirs cdirs
      );

    activation = {
      # configClean = dags.entryBefore ["checkLinkTargets"] ''
      # configClean = dags.entryBefore ["checkFilesChanged"] ''
      #   find "$HOME" -maxdepth 1 -type l -delete || true
      #   find "$HOME/bin" -maxdepth 1 -type l -delete || true
      #   find "$HOME/.config" -type l -delete || true
      # '';

      commonBinLinks = dags.entryAfter ["commonBins"] ''
        ln -fs ${dots}/global/bin/* "$HOME/bin/"
        ln -fs ${pkgs.vim}/bin/vim "$HOME/bin/svim"
      '';
      vimUpdate =
        dags.entryAfter ["commonBinLinks"]
        (
          utils.vimUpPrep
          + utils.vimUp ''"$HOME/bin/svim"''
          + utils.vimUp "${pkgs.neovim}/bin/nvim"
        );
    };
  };
}
