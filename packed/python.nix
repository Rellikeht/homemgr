# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  putils,
  ...
  # }}}
}: let
  # {{{ helpers
  b = builtins;
  u = putils;
  # }}}

  # {{{ versions
  pythonNew = pkgs.python313;
  pythonProv = pkgs.python312;
  pythonOld = pkgs.python311;
  # }}}

  # {{{ utils
  makePacks = ps:
    (pythonProv.withPackages ps)
    // (pythonNew.withPackages ps);
  makeAllPacks = ps:
    (makePacks ps) // (pythonOld.withPackages ps);
  # }}}

  # {{{ pkgs
  normalPkgs = with pkgs; [
    # {{{
  ]; # }}}

  unstablePkgs = with unstable; [
    # {{{
  ]; # }}}

  addNormalPkgs = with pkgs; [
    # {{{
  ]; # }}}

  addUnstablePkgs = with unstable; [
    # {{{
    pylyzer
    ruff
  ]; # }}}

  extraNormalPkgs = with pkgs; [
    # {{{
    pypy310
  ]; # }}}

  extraUnstablePkgs = with unstable; [
    # {{{
  ]; # }}}
  # }}}

  # {{{ sets
  pythonEssentialPkgs = ps:
    with ps; [
      # {{{
      bpython
      pip
      pynvim
    ]; # }}}

  pythonMinPkgs = ps:
    with ps; [
      # {{{
      python-lsp-server
      mypy
      pylsp-mypy
      yt-dlp
      gdown
    ]; # }}}

  pythonAddPkgs = ps:
    with ps; [
      # {{{
      numpy
      pandas
      # }}}
    ];

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
      sympy
      scipy
      # }}}
    ];
  # }}}
in rec {
  inherit pythonProv pythonNew pythonOld;
  inherit normalPkgs unstablePkgs;
  inherit addNormalPkgs addUnstablePkgs;

  pythonEssential =
    pythonProv.withPackages
    ( # {{{
      ps:
        u.sumPs ps
        [pythonEssentialPkgs]
    ); # }}}

  pythonSimple =
    pythonProv.withPackages
    ( # {{{
      ps:
        u.sumPs ps
        [
          # {{{
          pythonEssentialPkgs
          pythonMinPkgs
        ] # }}}
    ); # }}}

  pythonScraping =
    pythonProv.withPackages
    ( # {{{
      ps:
        u.sumPs ps
        [
          # {{{
          pythonEssentialPkgs
          pythonMinPkgs
          pythonAddPkgs
          pythonScrapPkgs
          pythonScrapAddPkgs
        ] # }}}
    ); # }}}

  pythonAdditions = pythonSimple; # TODO

  pythonFull =
    pythonProv.withPackages
    ( # {{{
      ps:
        u.sumPs ps
        [
          # {{{
          pythonEssentialPkgs
          pythonMinPkgs
          pythonAddPkgs

          pythonAddTools
          pythonData
          jupyterClient
        ] # }}}
    ); # }}}

  #
}
