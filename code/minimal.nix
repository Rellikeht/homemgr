# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  # lib,
  # dotfiles,
  # name,
  # stateVersion,
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

  normalPackages = with pkgs; [
    shfmt
    guile
    lua-language-server
    nickel
    nls
  ];

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
      GUILE_LOAD_PATH = utils.guileLoadPath guile-libs;
    };

    file = {
      # ".dhall/Prelude" = {
      #   source = dhallPrelude;
      # };
    };

    packages = normalPackages ++ unstablePackages ++ guile-libs;
  };
}
