# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  lib,
  utils,
  pythonProv,
  ...
}: let
  b = builtins;
  normalPackages = with pkgs; [
  ];

  unstablePackages = with unstable; [
    pylyzer
    ruff
    spotdl
  ];

  python = pythonProv.withPackages (ps:
    with ps; [
      bpython
      pip
      python-lsp-server
      mypy
      pylsp-mypy
      pynvim

      yt-dlp
      spotipy

      beautifulsoup4
      types-beautifulsoup4

      aria2p
      pycurl
      transmission-rpc
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
      ++ [(lib.setPrio 300 python)];
  };
}
