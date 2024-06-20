# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  lib,
  dotfiles,
  homeDir ? "",
  stateVersion,
  name,
  utils,
  ...
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
  # }}}

  # {{{
  defHomeDir = "/home/${name}";
  homeDirectory =
    if homeDir == ""
    then defHomeDir
    else homeDir;
  # }}}
in {
  home = {
    file =
      {
        # {{{
      } # }}}
      // b.listToAttrs (utils.configFiles [
        # {{{
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

        ".aliasrc.zsh"
        ".aliasrc.bash"
        ".funcrc.zsh"
        ".funcrc.bash"
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
        ".vim"
        ".w3m"
        ".scrs"
        "Templates"
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
        "bpython"
        "ocaml"
        "vifm"
        "git"
        "direnv"
        "fastfetch"
        "glow"
      ]);
    # }}}

    activation = {
      # {{{
      commonDirs =
        dags.entryAfter ["writeBoundary"]
        (
          ''
          ''
          + (utils.createDirs [
            "bin"
            ".local/run"
          ])
          + ''
            chmod 750 $HOME
          ''
        );

      # commonBins = dags.entryAfter ["installPackages"] ''
      commonBins = dags.entryAfter ["commonDirs"] ''
        find "$HOME/bin" -type l -delete || true
        ln -s "${pkgs.gnugrep}/bin/grep" "${homeDirectory}/bin/its_just_grep"
      '';

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
    }; # }}}

    inherit homeDirectory stateVersion;
  };
}
