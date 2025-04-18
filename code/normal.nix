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
  dags = lib.hm.dag;
  # dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; (
    [
      # {{{
      checkbashisms

      megatools

      pkgtop
      kakoune
      dune_3

      sbcl
      elixir
      elixir-ls

      cmake
      cmake-format

      clang-tools
      (clang // {meta.priority = 10;})
      rustfmt
      astyle
      html-tidy
      superhtml

      binutils
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
      ocamlformat
      ocaml-lsp
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
    ++ (with nodePackages; [
      prettier
    ])
  );

  unstablePackages = with unstable; ([
      # {{{
      zig
      zig-shell-completions
      zls
      ghc

      nim
      nimlangserver
      nimble

      gopls
      gotools
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
    with packed.lua; let
      luap = luaP // {meta.priority = 9;};
    in (
      [
        # {{{
        (luajitP // {meta.priority = 10;})
        luap
        (luaWrapper luap)
        # }}}
      ]
      ++ luaMinPkgs
      ++ luaMinUnstablePkgs
      ++ luaNormalPkgs
      ++ luaUnstablePkgs
    ); # }}}

  # TODO
  python = with packed.python; ( # {{{
    normalPkgs
    ++ unstablePkgs
    ++ [
      # {{{
      (pythonAdditions // {meta.priority = 9;})
    ] # }}}
  );
  # }}}
in {
  home = {
    sessionVariables = {
      # {{{
    }; # }}}

    file = {
      # {{{
    }; # }}}

    activation = {
      # {{{

      # opamActivation =
      #   dags.entryAfter ["installPackages"]
      #   # {{{
      #   ''
      #     export PATH="$PATH:${pkgs.gitFull}/bin"
      #     export PATH="$PATH:${pkgs.mercurialFull}/bin:${pkgs.rsync}/bin"
      #     export PATH="$PATH:${pkgs.rsync}/bin"
      #     export PATH="$PATH:${pkgs.gcc}/bin"
      #     export PATH="$PATH:${pkgs.gnumake}/bin"
      #     export PATH="$PATH:${pkgs.gnutar}/bin"
      #     export PATH="$PATH:${pkgs.gzip}/bin"
      #     export PATH="$PATH:${pkgs.diffutils}/bin"
      #     export PATH="$PATH:${pkgs.gnupatch}/bin"

      #     ${unstable.opam}/bin/opam init --no
      #   '';
      # # }}}
    }; # }}}

    packages =
      normalPackages
      ++ lua
      ++ python
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
