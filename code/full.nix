# vim: set et sw=2 ts=2:
{
  # {{{
  # config,
  pkgs,
  unstable,
  builds,
  lib,
  # dotfiles,
  # name,
  # stateVersion,
  # utils,
  ...
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";
  # }}}

  # {{{
  # I won't use this anyway
  # myR = pkgs.rWrapper.override {
  #   packages = with pkgs.rPackages;
  #     [
  #       ggplot2
  #       units
  #       languageserver
  #       vioplot
  #     ]
  #     ++ (with pkgs; [udunits]);
  # };
  # }}}

  normalPackages = with pkgs;
  # {{{
    ([
        tesseract
        pypy310
        jdt-language-server

        erlang
        tcl
        clisp
        pforth
        gforth

        vscode-langservers-extracted
        typescript
        (plan9port // {meta.priority = 6;})
      ] # }}}
      ++ (with nodePackages_latest; [
        # {{{
        typescript-language-server
      ])) # }}}
    ++ [
      # {{{
    ]; # }}}

  unstablePackages = with unstable; ([
      # {{{
      rustc
      rust-analyzer
      julia-bin

      nimble
      gdb
    ] # }}}
    ++ (with haskellPackages; [
      # {{{
      vector
      hashtables
      unordered-containers

      # dhall-nixpkgs
      # dhall-bash
      # dhall-docs
    ])); # }}}

  myBuilds = with builds; [
    # {{{
    minizinc-ide-bin
  ]; # }}}
  # TODO julia, ocaml, nim packages
  # homeDirectory = "/home/${name}";
in {
  home = {
    file = {
      # {{{
    }; # }}}

    activation = {
      # {{{
    }; # }}}

    sessionVariables = {
      # {{{
    }; # }}}

    packages =
      # {{{
      normalPackages
      ++ unstablePackages
      ++ myBuilds;
    # }}}
  };
}
# TODO custom ocaml compiler
# TODO language package managers
#
# julia
# "LanguageServer"
# "OhMyREPL"
# "Revise"
# "BenchmarkTools"

