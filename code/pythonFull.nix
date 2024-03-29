# vim: set et sw=2 ts=2:
{
  pkgs,
  # config,
  unstable,
  lib,
  # dotfiles,
  # name,
  # stateVersion,
  # utils,
  pythonProv,
  ...
}: let
  # b = builtins;
  # dots = "${dotfiles}";
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

      # TODO more useless packages
      matplotlib
      numpy
      pandas
      sympy
    ]);
in {
  home = {
    packages =
      normalPackages
      ++ unstablePackages
      ++ [(lib.setPrio 200 python)];
  };
}
