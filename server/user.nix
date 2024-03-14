# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  builds,
  lib,
  # dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";

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
  ];

  unstable_packages = with unstable; [
  ];

  myBuilds = with builds; [
  ];

  java = with pkgs; [
    (lib.setPrio 200 jre_minimal)
  ];
  # homeDirectory = "/home/${name}";
in {
  home = {
    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file =
      {
        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      }
      // b.listToAttrs (utils.configFiles [
        ])
      // b.listToAttrs (utils.configDirs [
        ])
      // b.listToAttrs (utils.configCDirs [
        "kak"
      ])
      // (utils.javaPaths java);

    sessionVariables = {
      # why the fuck doesn't this work??
      # PATH = "$PATH:${homeDirectory}/bin";
      # Maybe...
      # PATH = "$PATH:$HOME/bin";
    };

    activation = {
      userServerDirs = dags.entryAfter ["serverDirs"] (
        (utils.createDirs [
          ])
        + ''
        ''
      );

      userServerBins =
        dags.entryAfter ["commonBins"] ''
        '';
    };

    packages = normalPackages ++ unstable_packages ++ java ++ myBuilds;
  };
}
