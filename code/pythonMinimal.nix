# vim: set et sw=2 ts=2:
{
  pkgs,
  config,
  unstable,
  lib,
  dotfiles,
  name,
  stateVersion,
  utils,
  pythonProv,
  ...
}: let
  b = builtins;
  dots = "${dotfiles}";

  normalPackages = with pkgs; [
    pylyzer
    ruff
  ];

  unstablePackages = with unstable; [
  ];

  python = pythonProv.withPackages pythonPackages;
  pythonPackages = ps:
    with ps; [
      bpython
      pip
      python-lsp-server
      pynvim
      flake8
      autopep8
      yt-dlp
    ];
in {
  home = {
    packages =
      normalPackages
      ++ unstablePackages
      ++ [(lib.setPrio 200 python)];
  };
}
