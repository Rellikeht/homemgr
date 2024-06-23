# vim: set et sw=2 ts=2:
{
  pkgs,
  # config,
  unstable,
  lib,
  # utils,
  pythonProv,
  ...
}: let
  # b = builtins;
  normalPackages = with pkgs; [
    pypy310
  ];

  unstablePackages = with unstable; [
    pylyzer
    ruff
  ];

  python = pythonProv.withPackages (ps:
    with ps; [
      bpython
      pip
      python-lsp-server
      mypy
      pylsp-mypy
      pynvim
      flake8
      autopep8
      yt-dlp

      conda # ??

      jupyter-client
      pnglatex
      pyperclip
      cairosvg

      matplotlib
      numpy
      pandas
      sympy

      aria2p
      pycurl
    ]);
in {
  home = {
    packages =
      normalPackages
      ++ unstablePackages
      ++ [(lib.setPrio 300 python)];
  };
}
