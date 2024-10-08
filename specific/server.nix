# vim: set et sw=2 ts=2:
{
  # {{{
  # config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  # name,
  # stateVersion,
  # utils,
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
    file = {
      ".config/nvim" = {
        # {{{
        recursive = true;
        source = "${dotfiles}/.config/nvim-server";
        force = true;
      }; # }}}

      ".p10k.zsh" = {
        # {{{
        recursive = true;
        source = "${dotfiles}/p10ks/server.zsh";
        force = true;
      }; # }}}

      ".prompt.bash" = {
        # {{{
        recursive = true;
        source = "${dotfiles}/prompts/server.bash";
        force = true;
      }; # }}}
    };

    activation = {
      # {{{
    }; # }}}

    sessionVariables = {
      # {{{
    }; # }}}

    packages = normalPackages ++ unstablePackages;
  };
}
