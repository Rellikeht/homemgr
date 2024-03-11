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

    pforth

    dhall-nix
    dhall-nixpkgs
    dhall-bash
    dhall-docs
  ];

  unstablePackages = with unstable;
    [
      ghc
      julia
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

