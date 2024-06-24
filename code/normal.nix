# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  packed,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  # dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; (
    [
      # {{{
      megatools

      pkgtop
      kakoune
      dune_3

      gforth
      tcl
      sbcl
      clisp

      cmake
      cmake-format

      clang-tools
      (lib.setPrio 100 clang)
      rustfmt
      astyle
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
      ocamlformat
      # git

      # ocaml_pcre
      # re

      # iter
      # owl
      # zarith
      # yojson
      # csv
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
      floskell
      haskell-language-server
      cabal-install
      stack
    ]) # }}}
  );

  unstablePackages = with unstable; ([
      # {{{
      zig
      zig-shell-completions
      zls
      ghc

      gopls
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ])); # }}}

  # TODO
  lua =
    # {{{
    with packed.lua; (
      [
        # {{{
        (lib.setPrio 150 lua)
        (lib.setPrio 100 luajit)
        # }}}
      ]
      ++ luaMinimalPkgs
      ++ luaNormalPkgs
      ++ luaUnstablePkgs
    ); # }}}
in {
  home = {
    sessionVariables = {
      # {{{
    }; # }}}

    file = {
      # {{{
    }; # }}}

    packages =
      normalPackages
      ++ lua
      ++ unstablePackages;
  };

  programs = {
    opam = {
      # {{{
      enable = true;
      package = unstable.opam;

      # It is in dotfiles already
      enableBashIntegration = false;
      enableZshIntegration = false;
    }; # }}}

    vim-vint = {
      # {{{
      enable = true;
      package = unstable.vim-vint;
    }; # }}}
  };
}
