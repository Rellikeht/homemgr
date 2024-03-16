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

    gnumake
    automake
    cmake
    cmake-format
  ];

  unstablePackages = with unstable; ([
      zig
      zig-shell-completions
      zls
      ghc

      gopls
    ]
    ++ (with ocamlPackages; [
      # Almost all of that is one big ???
      utop
      git

      ocamlformat

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

    file = {
    };

    packages = normalPackages ++ unstablePackages;
  };
}
