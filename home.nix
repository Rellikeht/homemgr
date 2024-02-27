# vim: set et sw=2 ts=2:
{
  config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";

  # TODO bpython

  unstable_packages = with unstable; [
    nixd
    gdown
    nim
    nimlsp
    nimble

    ocaml
    ocamlPackages.ocaml-lsp
    ocamlPackages.utop
    ocamlformat
  ];

  jdks = with pkgs; [
    jdk17_headless
  ];

  jdkPaths = b.listToAttrs (map (n: {
      name = n.name;
      value = {
        target = ".jdks/" + n.name;
        recursive = true;
        source = "${n}/";
      };
    })
    jdks);
  # (map (x: b.trace x.outPath x) jdks));
  # TODO jdk vars, version is long, there should be something shorter

  configFiles = map (f: {
    name = f;
    value = {source = "${dotfiles}/" + f;};
  });

  configDirs = map (f: {
    name = f;
    value = {
      recursive = true;
      source = "${dotfiles}/" + f;
    };
  });

  configCDirs = map (f: {
    name = ".config/" + f;
    value = {
      recursive = true;
      source = "${dotfiles}/.config/" + f;
    };
  });

  dirMode = "750";
  dirCreate = n: ''
    mkdir -p $HOME/${n}
    chmod ${dirMode} $HOME/${n}
  '';
  createDirs = l: b.concatStringsSep "\n" (map dirCreate l);

  homeDirectory = "/home/${name}";
in {
  home = {
    inherit homeDirectory;
    username = name;

    packages = with pkgs;
      [
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

        direnv
        nix-direnv
        alejandra
        shellcheck
        checkbashisms
        glow

        silver-searcher
        gnugrep

        # nmap
        iperf3
        aria
        lftp
        rsync
        megatools
        rclone

        lua-language-server
        pylyzer
        ruff
        go
        gopls
        jq
      ]
      ++ jdks
      ++ unstable_packages;

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
      // b.listToAttrs (configFiles [
        ".vimrc"
        ".tmux.conf"
        ".guile"

        ".zshrc"
        ".bashrc"
        ".aliasrc"
        ".funcrc"
        ".varrc"
      ])
      // b.listToAttrs (configDirs [
        ".vim"
        ".w3m"
      ])
      // b.listToAttrs (configCDirs [
        "nvim"
        "kak"
        "glow"

        "nim"
        "ocaml"

        "yt-dlp"
        "transmission"
        "transmission-daemon"
      ])
      // jdkPaths;

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. If you don't want to manage your shell through Home
    # Manager then you have to manually source 'hm-session-vars.sh' located at
    # either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/michal/etc/profile.d/hm-session-vars.sh

    sessionVariables = {
      # why the fuck doesn't this work??
      PATH = "$PATH:${homeDirectory}/bin";
    };

    activation = {
      dirs = dags.entryAfter ["writeBoundary"] (
        (createDirs [
          "bin"
          "backups"
          "transmission/incomplete"
          "transmission/download"

          "Downloads"
          "Share"
          "Something"
        ])
        + ''
          rm -rf ${homeDirectory}/bin/its_just_grep
          ln -s ${pkgs.gnugrep}/bin/grep ${homeDirectory}/bin/its_just_grep
        ''
        + ''
          mkdir -p $HOME/Public
          chmod 777 $HOME/Public

          find $HOME/bin -xtype l -delete
          ln -fs ${dots}/global/bin/* $HOME/bin/
          chmod 750 $HOME
        ''
      );
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
