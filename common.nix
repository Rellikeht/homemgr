# vim: set et sw=2 ts=2:
{
  config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  # homeDirectory ? "/home/${name}",
  stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";

  normalPackages = with pkgs; [
    direnv
    nix-direnv
    alejandra
    silver-searcher
    gnugrep

    iperf3
    aria
    rsync
    jq
  ];

  unstablePackages = with unstable; [
    nixd
    ocaml
  ];

  homeDirectory = "/home/${name}";
in {
  inherit homeDirectory stateVersion;
  username = name;
  packages = normalPackages ++ unstablePackages;

  file =
    {}
    // b.listToAttrs (utils.configFiles [
      ".vimrc"
      ".tmux.conf"
      ".guile"

      ".zshrc"
      ".bashrc"
      ".aliasrc"
      ".funcrc"
      ".varrc"
    ])
    // b.listToAttrs (utils.configDirs [
      ".vim"
      ".w3m"
    ])
    // b.listToAttrs (utils.configCDirs [
      "ocaml"
    ]);

  activation = {
    commonDirs =
      dags.entryAfter ["writeBoundary"]
      (utils.createDirs ["bin"])
      + ''
        chmod 750 $HOME
      '';

    commonBins = dags.entryAfter ["writeBoundary"] ''
      find $HOME/bin -xtype l -delete
      ln -fs ${dots}/global/bin/* $HOME/bin/

      rm -rf ${homeDirectory}/bin/its_just_grep
      ln -s ${pkgs.gnugrep}/bin/grep ${homeDirectory}/bin/its_just_grep
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
