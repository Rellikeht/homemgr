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
    jre8_headless
    jdk11_headless
    jdk17_headless
    jdk21_headless
  ];
in {
  home = {
    file =
      {}
      // (utils.javaPaths java);

    packages = normalPackages ++ unstablePackages ++ java;
  };
}
