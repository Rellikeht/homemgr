# vim: set et sw=2 ts=2:
{
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
    shellcheck
    checkbashisms

    alejandra
    silver-searcher
    dash

    glow
    nil
    jq
    gitFull
    delta
    rlwrap
    (lib.setPrio 100 python313)
  ];

  unstablePackages = with unstable; [
    # nixd
    aria2
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
          ''
          + (utils.createDirs [
            "bin"
          ])
          + ''
            chmod 750 $HOME
          ''
        );

      # commonBins = dags.entryAfter ["installPackages"] ''
      commonBins = dags.entryAfter ["commonDirs"] ''
        find "$HOME/bin" -type l -delete || true
        ln -s "${pkgs.gnugrep}/bin/grep" "${homeDirectory}/bin/its_just_grep"
      '';
    };

    inherit homeDirectory stateVersion;
    username = name;
    packages = normalPackages ++ unstablePackages;
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  # ???
  aria = {
    enable = true;
  };

  news.display = "silent";
}
