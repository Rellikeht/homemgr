# vim: set et sw=2 ts=2:
{
  config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  stateVersion,
  utils,
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

  opkgs = pkgs.stdenv.lib.overrideDerivation; # TODO
  pythonProv = pkgs.python311;
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
    packages = normalPackages ++ unstablePackages ++ [python];
  };
}
