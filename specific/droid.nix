# vim: set et sw=2 ts=2:
{
  # {{{
  config,
  pkgs,
  unstable,
  dotfiles,
  minimized,
  utils,
  # old,
  # lib,
  # name,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  # }}}

  normalPackages = with pkgs; (
    [
      # {{{
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ]) # }}}
  );

  unstablePackages = with unstable; ([
      # {{{
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
      # FUCK
      # lsp
      # ocaml-lsp
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ])); # }}}
  # oldPackages = with old; [
  #   # {{{
  #   # ocamlPackages.ocaml-lsp
  # ]; # }}}
in {
  home = {
    file =
      {
        # {{{
        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/p10ks/droid.zsh";
          force = true;
        }; # }}}

        ".prompt.bash" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/prompts/droid.bash";
          force = true;
        }; # }}}

        ".config/nvim" = {
          # {{{
          recursive = true;
          source = "${minimized}/.config/nvim";
          force = true;
        }; # }}}

        "storage" = {
          source = mkOutOfStoreSymlink /storage/emulated/0;
          force = true;
        };
      } # }}}
      // b.listToAttrs (utils.configFiles [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
      ]); # }}}

    activation = {
      # {{{
    }; # }}}

    packages = normalPackages ++ unstablePackages;
  };
}
