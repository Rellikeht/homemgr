# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  # lib,
  # dotfiles,
  # name,
  utils,
  # dhallPrelude,
  ...
}: let
  b = builtins;

  guile-libs = with pkgs; [
    guile-git
    guile-ssh
    guile-gnutls
  ];

  normalPackages = with pkgs; (
    [
      shfmt
      guile
      lua-language-server
      luaformatter
      nickel
      nls
    ]
    ++ (with lua54Packages; [
      luacheck
    ])
    ++ (with ocamlPackages; [
      utop
      ocaml-lsp
    ])
    ++ (with haskellPackages; [
      # dhall
      # dhall-yaml
      # dhall-json
      # dhall-nix
      # dhall-toml
    ])
  );

  unstablePackages = with unstable; ([
      go

      nim
      nimlsp
      nimble

      tree-sitter
    ]
    ++ (with ocamlPackages; [
      ])
    ++ (with haskellPackages; [
      ]));
  # dots = "${dotfiles}";
in {
  home = {
    sessionVariables = {
      GUILE_LOAD_PATH = utils.guile.guileLoadPath guile-libs;
    };

    file = {
      # ".dhall/Prelude" = {
      #   source = dhallPrelude;
      # };
    };

    packages = normalPackages ++ unstablePackages ++ guile-libs;
  };
}
