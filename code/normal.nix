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

  normalPackages = with pkgs; [
    kakoune
    luajit

    gforth
    tcl
    sbcl
    clisp
  ];

  unstablePackages = with unstable; ([
      zig
      zig-shell-completions
      zls
      ghc

      gnumake
      automake
      cmake

      ocamlformat
      gopls
    ]
    ++ (with ocamlPackages; [
      # Almost all of that is one big ???
      utop
      git

      ocaml_pcre
      re

      iter
      owl
      zarith

      yojson
      csv
    ])
    ++ (with haskellPackages; [
      floskell
      haskell-language-server
      cabal-install
      stack
    ]));
  # dots = "${dotfiles}";
in {
  home = {
    sessionVariables = {
    };

    file =
      {
      }
      // b.listToAttrs (utils.configDirs [
        ])
      // b.listToAttrs (utils.configCDirs [
        "kak"
      ]);

    packages = normalPackages ++ unstablePackages;
  };
}
