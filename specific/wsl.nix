# vim: set et sw=2 ts=2:
{
  # {{{
  # config,
  pkgs,
  unstable,
  dotfiles,
  minimized,
  utils,
  # lib,
  ...
  # }}}
}: let
  # {{{
  # dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; (
    [
      # {{{
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
      ocaml-lsp
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
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ])); # }}}
in {
  home = {
    file =
      {
        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/p10ks/wsl.zsh";
          force = true;
        }; # }}}

        ".config/nvim" = {
          # {{{
          recursive = true;
          source = "${minimized}/.config/nvim";
          force = true;
        }; # }}}
      }
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

    sessionVariables = {
      # {{{
    }; # }}}

    packages = normalPackages ++ unstablePackages;
  };
}
