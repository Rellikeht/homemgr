# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  builds,
  lib,
  # dotfiles,
  name,
  # stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";

  normalPackages = with pkgs; [
    shellcheck
    checkbashisms
    glow

    # yt-dlp
    nmap
    lftp
    megatools
    rclone
    transmission
  ];

  unstablePackages = with unstable; [
    gdown
    nim
    go
  ];

  myBuilds = with builds; [
    playit-bin
  ];
  # homeDirectory = "/home/${name}";
in {
  home = {
    file = {};

    activation = {
      serverDirs = dags.entryAfter ["commonDirs"] (
        (utils.createDirs [
          "Backups"
          "transmission/incomplete"
          "transmission/download"

          "Downloads"
          "Share"
          "Something"
        ])
        + ''
          mkdir -p $HOME/Public
          chmod 777 $HOME/Public
        ''
      );
    };

    packages = normalPackages ++ unstablePackages ++ myBuilds;
  };
}
