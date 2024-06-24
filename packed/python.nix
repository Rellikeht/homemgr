# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  lib,
  ...
}: let
  # {{{
  b = builtins;
  u = import ./utils.nix {inherit lib;};
  # }}}

  # {{{
  pythonNew = pkgs.python313;
  pythonProv = pkgs.python312;
  pythonOld = pkgs.python311;
  # }}}

  normalPkgs = with pkgs; [
    # {{{
  ]; # }}}

  unstablePkgs = with unstable; [
    # {{{
  ]; # }}}

  addNormalPkgs = with pkgs; [
    # {{{
    pypy310
  ]; # }}}

  addUnstablePkgs = with unstable; [
    # {{{
    pylyzer
    ruff
  ]; # }}}

  pythonMinPkgs = ps:
    with ps; [
      # {{{
      bpython
      pip
      python-lsp-server
      mypy
      pylsp-mypy
      pynvim
      yt-dlp
      gdown
    ]; # }}}

  pythonScrapPkgs = ps:
    with ps; [
      # {{{
      spotipy
      beautifulsoup4
      types-beautifulsoup4
      pycurl
    ]; # }}}

  pythonScrapAddPkgs = ps:
    with ps; [
      # {{{
      aria2p
      transmission-rpc
    ]; # }}}

  pythonAddTools = ps:
    with ps; [
      # {{{
      flake8
      # autopep8
      conda # ??
    ]; # }}}

  jupyterClient = ps:
    with ps; [
      # {{{
      jupyter-client
      pnglatex
      pyperclip
      cairosvg
    ]; # }}}

  pythonData = ps:
    with ps; [
      # {{{
      matplotlib
      numpy
      pandas
      sympy
      # }}}
    ];
in {
  inherit normalPkgs unstablePkgs;
  inherit addNormalPkgs addUnstablePkgs;
}
