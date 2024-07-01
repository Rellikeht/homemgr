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

    # TODO z.lua and z.sh file
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

      zlua = dags.entryAfter ["writeBoundary"] ''
        pushd "$HOME"

        if [ -e .z ] && ! [ -f .z ]; then
          echo ".z should be readable file"
          exit 1
        elif [ -e .zlua ] && ! [ -f .zlua ]; then
          echo ".zlua should be readable file"
          exit 1
        fi

        if ! [ -e .z ]; then
          if ! [ -e .zlua ]; then
            touch .zlua
          fi
        else
          if ! [ -e .zlua ]; then
            mv .z .zlua
          else
            # merge
            TEMP="$(mktemp)"
            sort -u -t'|' -k1,1 .z .zlua > "$TEMP"
            rm .z .zlua
            cp "$TEMP" .zlua
            rm "$TEMP"
          fi
        fi

        ln -s .zlua .z
        popd
      '';
    }; # }}}

    inherit homeDirectory stateVersion;
  };
}
