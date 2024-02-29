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

  guile-libs = with pkgs; [
    guile-git
    guile-ssh
    guile-gnutls
  ];

  normalPackages = with pkgs; [
    guile

    lua-language-server
    pylyzer
    ruff
  ];

  unstablePackages = with unstable; [
    ocamlPackages.ocaml-lsp
    ocamlPackages.utop
    ocamlformat

    nim
    nimlsp
    nimble

    gopls
  ];

  dots = "${dotfiles}";
in {
  home = {
    sessionVariables = {
      GUILE_LOAD_PATH = let
        siteDir = "${pkgs.guile.siteDir}";
      in (b.concatStringsSep ";"
        (map (l: "${l}/${siteDir}") guile-libs));
    };

    file =
      {}
      // b.listToAttrs (utils.configDirs [
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "nvim"
        "nim"
      ]);

    packages = normalPackages ++ unstablePackages ++ guile-libs;
  };
}
