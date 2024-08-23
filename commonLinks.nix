# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
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
        ".vintrc"
        ".tmux.conf"
        ".guile"

        ".zshrc"
        ".bashrc"
        ".inputrc"

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
        ".bash"
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
      commonDirs =
        # {{{
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
        ); # }}}

      commonBins =
        # {{{
        dags.entryAfter ["commonDirs"] ''
          mkdir -p "$HOME/bin"
          mkdir -p "$HOME/.local/bin"
          find "$HOME/bin" -type l -delete || true
        ''; # }}}

      commonBinLinks =
        # {{{
        dags.entryAfter ["commonBins"] ''
          ln -fs ${dots}/bin/* "$HOME/bin"
          ln -fs ${unstable.vim}/bin/vim "$HOME/bin/svim"
        ''; # }}}

      zlua =
        # {{{
        dags.entryAfter ["writeBoundary"] ''
          pushd "$HOME" &>/dev/null

          if [ -e .z ] && ! ([ -f .z ] || [ -L .z ]); then
            echo ".z should be readable file or symlink to .zlua"
            exit 1
          elif [ -e .zlua ] && ! ([ -f .zlua ] || [ -L .zlua ]); then
            echo ".zlua should be readable file or symlink"
            exit 1
          else

            if ! [ -e .z ]; then
              if ! [ -e .zlua ]; then
                touch .zlua
              fi
              ln -s .zlua .z

            else
              if ! [ -e .zlua ]; then
                mv .z .zlua
                ln -s .zlua .z
              elif [ "$(readlink -f .z)" != "$(readlink -f .zlua)" ] ||
                ! diff -q .z .zlua &>/dev/null; then
                # merge
                TEMP="$(mktemp)"
                sort -nr -t'|' -k3,3 .z .zlua > "$TEMP"
                sort -s -u -t'|' -k1,1 "$TEMP" > .zlua
                rm .z
                rm "$TEMP"
                ln -s .zlua .z
              fi
            fi

          fi
          popd &>/dev/null
        ''; # }}}

      touchingFiles =
        # {{{
        dags.entryAfter ["writeBoundary"]
        ''
          touch "$HOME/.config/vifm/vifmrc-local"
        ''; # }}}
    };

    inherit homeDirectory stateVersion;
  };
}
