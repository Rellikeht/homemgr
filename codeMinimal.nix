# vim: set et sw=2 ts=2:
{
  config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  stateVersion,
  utils,
  ...
}: let
  b = builtins;

  normalPackages = with pkgs; [
    lua-language-server
    pylyzer
    ruff
    gopls
  ];

  unstablePackages = with unstable; [
    ocamlPackages.ocaml-lsp
    ocamlPackages.utop
    ocamlformat

    nim
    nimlsp
    nimble
  ];

  # todo guile

  dots = "${dotfiles}";
in {
  home = {
    files =
      {}
      // b.listToAttrs (utils.configDirs [
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "nvim"
        "nim"
      ]);

    packages = normalPackages ++ unstablePackages;
  };
}
