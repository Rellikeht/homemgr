# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  # unstable,
  lib,
  # dotfiles,
  name,
  homeDir,
  # stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;

  b = builtins;
  # dots = "${dotfiles}";

  defHomeDir = "/home/${name}";
  homeDirectory =
    if homeDir == ""
    then defHomeDir
    else homeDir;
in {
  home = {
    file = {
      # ".alacritty.toml" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.alacritty.toml;};
      # ".aliasrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.aliasrc;};
      # ".bashrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.bashrc;};
      # ".commonrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.commonrc;};
      # ".funcrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.funcrc;};
      # ".gitconfig" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.gitconfig;};
      # ".guile" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.guile;};
      # ".gvimrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.gvimrc;};
      # ".kb-plug.sh" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.kb-plug.sh;};
      # ".keynavrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.keynavrc;};
      # ".keynavrc.keyboard" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.keynavrc.keyboard;};
      # ".megarc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.megarc;};
      # ".screenrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.screenrc;};
      # ".tclshrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.tclshrc;};
      # ".tmux.conf" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.tmux.conf;};
      # ".varrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.varrc;};
      # ".vimrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.vimrc;};
      # ".xbindkeysrc.scm" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.xbindkeysrc.scm;};
      # ".xcape_run.sh" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.xcape_run.sh;};
      # ".xinitrc_common" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.xinitrc_common;};
      # ".xinitrc_dwm" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.xinitrc_dwm;};
      # ".xinitrc_i3" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.xinitrc_i3;};
      # ".xmodmaprc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.xmodmaprc;};
      # ".Xresources" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.Xresources;};
      # ".zshrc" = {source = "${homeDirectory}/" + gits/configs/dotfiles/.zshrc;};

      # ".config" = let
      #   src = "$HOME/gits/configs/dotfiles/.config" + ./.;
      # in {
      #   source = b.trace src src;
      #   recursive = true;
      # };

      # ".dscripts" = {
      #   source = "gits/configs/dotfiles/.dscripts";
      #   recursive = true;
      # };
      # ".dwm" = {
      #   source = "gits/configs/dotfiles/.dwm";
      #   recursive = true;
      # };
      # ".julia" = {
      #   source = "gits/configs/dotfiles/.julia";
      #   recursive = true;
      # };
      # ".scrs" = {
      #   source = "gits/configs/dotfiles/.scrs";
      #   recursive = true;
      # };
      # "Templates" = {
      #   source = "gits/configs/dotfiles/Templates";
      #   recursive = true;
      # };
      # ".vim" = {
      #   source = "gits/configs/dotfiles/.vim";
      #   recursive = true;
      # };
      # ".w3m" = {
      #   source = "gits/configs/dotfiles/.w3m";
      #   recursive = true;
      # };
      # ".xmodmap" = {
      #   source = "gits/configs/dotfiles/.xmodmap";
      #   recursive = true;
      # };

      # .elinks
      # .emacs.d
      # .i3status.conf

      # .kshrc
      # .mkshrc
      # .moc
      # .nanorc
      # .pinforc
      # .starting_moves.sh
      # .twmrc
    };

    # TODO dotfile links
    activation = {
      gitLinks = let
        dots = "$HOME/gits/configs/dotfiles";
      in
        dags.entryAfter ["gits"] ''
          find -printf '%f\n' | \
            grep -Ev '^[^.].*|.config' | \
            xargs -d '\n' -I{} cp -frs "{}" "$HOME"

          cp -frs ${dots}/.config/* "$HOME/.config"
          ln -fs ${dots}/global/bin/* "$HOME/bin/"
        '';
      vimUpdate =
        dags.entryAfter ["gitLinks"]
        (
          utils.vimUpPrep
          + utils.vimUp ''"$HOME/bin/svim"''
          + utils.vimUp "${pkgs.neovim}/bin/nvim"
        );
    };

    sessionVariables = {};
  };
}
