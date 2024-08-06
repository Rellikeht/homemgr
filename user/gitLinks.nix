# vim: set et sw=2 ts=2:
{
  # {{{
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
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";
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
    file = {
      # {{{
    }; # }}}

    # TODO dotfile links
    activation = {
      gitLinks = let
        # {{{
        dots = "\"$HOME/gits/configs/dotfiles\"";
        # }}}
      in
        # {{{
        dags.entryAfter ["gits"] ''
          find ${dots} -mindepth 1 -maxdepth 1 -printf '%f\n' | \
            grep -Ev '^([^.].*|.config|.git[^c].*)' | \
            xargs -d '\n' -I{} cp -frs "{}" "$HOME"

          cp -frs ${dots}/.config/* "$HOME/.config"
          ln -fs ${dots}/global/bin/* "$HOME/bin/"
        '';
      # }}}

      vimUpdate =
        dags.entryAfter ["gitLinks"] # {{{
        
        (
          utils.apps.vimUpPrep
          + utils.apps.vimUp ''"$HOME/bin/svim"''
          + utils.apps.vimUp "${unstable.neovim}/bin/nvim"
          + ''
            unlink "$HOME/bin/svim"
          ''
        ); # }}}
    };

    sessionVariables = {
      # {{{
    }; # }}}
  };
}
