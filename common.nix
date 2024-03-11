# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  lib,
  # dotfiles,
  name,
  homeDir ? "",
  stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  # b = builtins;
  # dots = "${dotfiles}";

  normalPackages = with pkgs; [
    direnv
    nix-direnv
    alejandra
    silver-searcher
    gnugrep
    dash

    nil
    jq
    git
    delta
    rlwrap
    lua
    (lib.setPrio 100 python313)
  ];

  unstablePackages = with unstable; [
    # nixd
    ocaml
  ];

  defHomeDir = "/home/${name}";
  homeDirectory =
    if homeDir == ""
    then defHomeDir
    else homeDir;
in {
  home = {
    activation = {
      commonDirs =
        dags.entryAfter ["writeBoundary"]
        (
          ''
            # [ -e "$HOME/bin" ] && exit 1
          ''
          + (utils.createDirs [
            "bin"
          ])
          + ''
            chmod 750 $HOME
          ''
        );

      commonBins = dags.entryAfter ["commonDirs"] ''
        find "$HOME/bin" -xtype l -delete || true
        rm -rf "$HOME/bin/its_just_grep"
        ln -s "${pkgs.gnugrep}/bin/grep" "${homeDirectory}/bin/its_just_grep"
      '';
    };

    inherit homeDirectory stateVersion;
    username = name;
    packages = normalPackages ++ unstablePackages;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
