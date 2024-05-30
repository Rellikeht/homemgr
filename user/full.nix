# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";

  normalPackages = with pkgs; [];
  unstablePackages = with unstable; [];
  # homeDirectory = "/home/${name}";
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configCDirs [
        "vis"
      ]);

    activation = {};

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
