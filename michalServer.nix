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

  # TODO bpython
  normalPackages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    shellcheck
    checkbashisms
    glow

    nmap
    lftp
    megatools
    rclone

    lua-language-server
    pylyzer
    ruff
    gopls
    go
  ];

  unstable_packages = with unstable; [
    gdown
    nim
    nimlsp
    nimble

    ocamlPackages.ocaml-lsp
    ocamlPackages.utop
    ocamlformat
  ];

  jdks = with pkgs; [
    jdk17_headless
  ];

  homeDirectory = "/home/${name}";
in {
  home = {
    packages = normalPackages ++ unstable_packages ++ jdks;

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file =
      {
        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';

        # ".tmux.conf".source = "${dotfiles}/.tmux.conf";
        # ".vimrc".source = "${dotfiles}/.vimrc";
        # ".guile".source = "${dotfiles}/.guile";
      }
      // b.listToAttrs (utils.configFiles [
        ])
      // b.listToAttrs (utils.configDirs [
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "nvim"
        "kak"
        "glow"

        "nim"

        "yt-dlp"
        "transmission"
        "transmission-daemon"
      ])
      // (utils.jdkPaths jdks);

    sessionVariables = {
      # why the fuck doesn't this work??
      # PATH = "$PATH:${homeDirectory}/bin";
    };

    activation = {
      dirs = dags.entryAfter ["commonDirs"] (
        (utils.createDirs [
          "backups"
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

      bins =
        dags.entryAfter ["commonBins"] ''
        '';
    };
  };
}
