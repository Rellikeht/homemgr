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
    xz
    gnutar
    zip
    unzip
    dash
    vim
    w3m
  ];
  unstablePackages = with unstable; [];

  java = with pkgs; [
    (lib.setPrio 100 jre8_headless)
    (lib.setPrio 110 jdk11_headless)
    (lib.setPrio 120 jdk17_headless)
    (lib.setPrio 130 jdk21_headless)
  ];
in {
  home = {
    file =
      {}
      // (utils.javaPaths java);

    packages = normalPackages ++ unstablePackages ++ java;
  };
}
