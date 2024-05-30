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
  dots = "${dotfiles}";

  normalPackages = with pkgs; [
    kakoune
    w3m
  ];

  unstablePackages = with unstable; [
  ];
in {
  home = {
    packages = normalPackages ++ unstablePackages;
  };
}
