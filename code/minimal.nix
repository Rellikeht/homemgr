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

  normalPackages = with pkgs; ([
      shfmt
      guile
      lua-language-server
      luaformatter
      nickel
      nls
      megatools
    ]
    ++ (with lua54Packages; [
      luacheck
    ]));

  unstablePackages = with unstable; ([
      go

      nim
      nimlsp
      nimble

      dune_3

      tree-sitter
    ]
    ++ (with ocamlPackages; [
      ocaml-lsp
    ])
    ++ (with haskellPackages; [
      # dhall
      # dhall-yaml
      # dhall-json
      # dhall-nix
      # dhall-toml
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
