# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  utils,
  packed,
  ...
}: let
  # {{{
  b = builtins;
  # dots = "${dotfiles}";
  # }}}

  guile-libs = with pkgs; [
    # {{{
    guile-git
    guile-ssh
    guile-gnutls

    guile-json
    guile-sqlite3
    # guile-ncurses
  ]; # }}}

  normalPackages = with pkgs; (
    [
      # {{{
      shfmt
      guile
      nickel
      nls
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
      utop
      # ocaml-lsp
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
      # dhall
      # dhall-yaml
      # dhall-json
      # dhall-nix
      # dhall-toml
    ]) # }}}
  );

  unstablePackages = with unstable; ([
      # {{{
      go

      nim
      nimlsp
      nimble

      tree-sitter
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ])); # }}}

  lua =
    # {{{
    with packed.lua; (
      [
        # {{{
        (lib.setPrio 150 luaP)
        (lib.setPrio 100 luajitP)
        # }}}
      ]
      ++ luaMinPkgs
      ++ luaMinUnstablePkgs
      ++ luaNormalPkgs
      ++ luaUnstablePkgs
    ); # }}}

  python = with packed.python; ( # {{{
    normalPkgs
    ++ unstablePkgs
    ++ [
      # {{{
      (lib.setPrio 200 pythonSimple)
    ] # }}}
  );
  # }}}
in {
  home = {
    sessionVariables = {
      # {{{
      GUILE_LOAD_PATH = utils.guile.guileLoadPath guile-libs;
    }; # }}}

    file = {
      # {{{
      # ".dhall/Prelude" = {
      #   source = dhallPrelude;
      # };
    }; # }}}

    packages =
      normalPackages
      ++ unstablePackages
      ++ lua
      ++ python
      ++ guile-libs;
  };
}
