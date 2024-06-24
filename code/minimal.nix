# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  utils,
  luaProv,
  luajitProv,
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
    with (import ../packed/lua.nix {
      inherit pkgs unstable lib;
    });
    # }}}
      ( # {{{
        [
          # {{{
          lua
          luajit
          # }}}
        ]
        ++ luaMinimalPkgs
        ++ luaNormalPkgs
        ++ luaUnstablePkgs
      ); # }}}
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
      ++ b.trace (map (x: b.trace x x) lua) lua
      ++ guile-libs;
  };
}
