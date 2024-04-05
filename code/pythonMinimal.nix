# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  utils,
  pythonProv,
  ...
}: let
  b = builtins;
  # dots = "${dotfiles}";
  normalPackages = with pkgs; [
    pylyzer
    ruff
  ];

  unstablePackages = with unstable; [
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
    ]);
in {
  home = {
    file =
      {
      }
      // b.listToAttrs (utils.configDirs [
        ])
      // b.listToAttrs (utils.configCDirs [
        # "bpython"
      ]);

    packages =
      normalPackages
      ++ unstablePackages
      ++ [(lib.setPrio 200 python)];
  };
}
