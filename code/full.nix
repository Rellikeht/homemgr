# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  # stateVersion,
  # utils,
  ...
}: let
  dags = lib.hm.dag;
  # b = builtins;
  # dots = "${dotfiles}";

  normalPackages = with pkgs; [
    tesseract
    pypy310
    jdt-language-server

    julia
    pforth
  ];

  unstablePackages = with unstable;
    [
      ghc
    ]
    ++ (with unstable.haskellPackages; [
      cabal-install
      stack
      vector
      hashtables
      unordered-containers
    ]);
  # TODO julia, ocaml, nim packages
  # homeDirectory = "/home/${name}";
in {
  home = {
    file = {};

    activation = {};

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
# TODO maybe some R, totally useless so can wait

