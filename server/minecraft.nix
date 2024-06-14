# vim: set et sw=2 ts=2:
{
  # {{{
  # config,
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  utils,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  # dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; [
    # {{{
    xz
    gnutar
    zip
    unzip
    vim
    w3m

    # dash
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
  ]; # }}}

  java = with pkgs; [
    # {{{
    (lib.setPrio 100 jre8_headless)
    (lib.setPrio 110 jdk11_headless)
    (lib.setPrio 120 jdk17_headless)
    (lib.setPrio 130 jdk21_headless)
    # (lib.setPrio 140 jdk_headless)
  ]; # }}}
in {
  home = {
    file =
      {
        # {{{
      } # }}}
      // (utils.java.javaDumbPaths java)
      // (utils.java.javaNamePaths java);

    sessionVariables =
      {
        # {{{
      } # }}}
      // (utils.java.javaNameVars java)
      // (utils.java.javaDumbVars java);

    packages = normalPackages ++ unstablePackages ++ java;
  };
}
