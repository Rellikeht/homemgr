{
  # {{{
  pkgs,
  home-manager,
  dotfiles,
  lib,
  unstable,
  stateVersion,
  ...
  # }}}
} @ inputs: let
  # {{{ shortcuts
  dags = lib.hm.dag;
  b = builtins;
  confFunc = home-manager.lib.homeManagerConfiguration;

  # }}}

  # {{{ imports

  apps = import ./apps.nix inputs;
  git = import ./git.nix inputs;
  java = import ./java.nix inputs;
  guile = import ./guile.nix inputs;
  # }}}
in rec {
  # {{{ inherit
  inherit confFunc;
  inherit apps git java guile;
  # }}}

  # {{{ TODO

  # cron here, because it isn't available
  # somehow, no idea how hard this will be

  # }}}

  # {{{ string helpers

  firstUpper = str: let
    split = lib.stringToCharacters str;
    c = lib.head split;
    rest = lib.concatStrings (lib.tail split);
  in
    (lib.toUpper c) + rest;

  # }}}

  # {{{ config

  configFiles = map (f: {
    name = f;
    value = lib.mkDefault {
      source = "${dotfiles}/" + f;
      force = true;
    };
  });

  configDirs = map (f: {
    name = f;
    value = lib.mkDefault {
      recursive = true;
      source = "${dotfiles}/" + f;
      force = true;
    };
  });

  # configCDirs = l: configDirs (map (n: ".config/" + n) l);

  configCDirs = map (f: {
    name = ".config/" + f;
    value = lib.mkDefault {
      recursive = true;
      source = "${dotfiles}/.config/" + f;
      force = true;
    };
  });

  # }}}

  # {{{ dirs

  dirMode = "750";
  createDir = n: ''
    mkdir -p $HOME/${n}
    chmod ${dirMode} $HOME/${n}
  '';
  createDirs = l: b.concatStringsSep "\n" (map createDir l);

  # }}}
}
