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
  ...
}: let
  b = builtins;

  guile-libs = with pkgs; [
    guile-git
    guile-ssh
    guile-gnutls
  ];

  normalPackages = with pkgs; [
    guile
    lua-language-server

    dhall
    dhall-yaml
    dhall-json
    dhall-lsp-server
  ];

  unstablePackages = with unstable; [
    ocamlPackages.ocaml-lsp
    ocamlPackages.utop
    ocamlformat

    nim
    nimlsp
    nimble

    tree-sitter
    gopls
  ];
  # dots = "${dotfiles}";
in {
  home = {
    sessionVariables = {
      GUILE_LOAD_PATH = utils.guileLoadPath guile-libs;
    };

    file =
      {}
      // b.listToAttrs (utils.configDirs [
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "bpython"
        "nvim"
        "nim"
      ]);

    packages = normalPackages ++ unstablePackages ++ guile-libs;
  };
}
