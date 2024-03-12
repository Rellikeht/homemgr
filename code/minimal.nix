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
  dhallPrelude,
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
  ];

  unstablePackages = with unstable; ([
      ocamlformat

      nim
      nimlsp
      nimble

      tree-sitter
      gopls
    ]
    ++ (with ocamlPackages; [
      ocaml-lsp
      utop
    ])
    ++ (with haskellPackages; [
      dhall
      dhall-yaml
      dhall-json
      dhall-lsp-server
      dhall-nix
      dhall-toml
    ]));
  # dots = "${dotfiles}";
in {
  home = {
    sessionVariables = {
      GUILE_LOAD_PATH = utils.guileLoadPath guile-libs;
    };

    file =
      {
        ".dhall/Prelude" = {
          source = dhallPrelude;
        };
      }
      // b.listToAttrs (utils.configDirs [
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "bpython"
        "nvim"
        "nim"
      ]);

    # TODO dhall prelude
    packages = normalPackages ++ unstablePackages ++ guile-libs;
  };
}
