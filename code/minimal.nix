# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  # lib,
  # dotfiles,
  # name,
  utils,
  packed,
  ...
}: let
  # {{{
  # b = builtins;
  # dots = "${dotfiles}";
  # }}}
  guile-libs = with pkgs; [
    # {{{
    # guile-git
    # guile-ssh
    # guile-ncurses

    guile-sqlite3
    guile-gnutls
    guile-fibers
    guile-json
  ]; # }}}

  normalPackages = with pkgs; (
    [
      # {{{
      shfmt
      guile
      nickel
      nls
      nil
      ripgrep-all
      onefetch
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
      utop
      # ocaml-lsp
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ]) # }}}
  );

  unstablePackages = with unstable; ([
      # {{{
      go

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
    with packed.lua; let
      luap = luaP // {meta.priority = 9;};
    in (
      [
        # {{{
        (luajitP // {meta.priority = 10;})
        luap
        (luaWrapper luap)
        # }}}
      ]
      ++ luaMinPkgs
      ++ luaMinUnstablePkgs
      ++ luaNormalPkgs
      ++ luaUnstablePkgs
    ); # }}}
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
      ++ guile-libs;
  };
}
