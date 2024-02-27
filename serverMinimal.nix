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
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";

  normalPackages = with pkgs; [
    shellcheck
    checkbashisms
    glow

    go

    nmap
    lftp
    megatools
    rclone
  ];

  unstablePackages = with unstable; [
    gdown
    nim
  ];

  homeDirectory = "/home/${name}";
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configCDirs [
        "glow"
        "yt-dlp"
        "transmission"
        "transmission-daemon"
      ]);

    activation = {
      dirs = dags.entryAfter ["commonDirs"] (
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

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
