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
    (jre8_headless // {meta.priority = 12;})
    (jdk11_headless // {meta.priority = 11;})
    (jdk17_headless // {meta.priority = 10;})
    (jdk21_headless // {meta.priority = 9;})
    (jdk_headless // {meta.priority = 8;})
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
