{
  pkgs,
  home-manager,
  dotfiles,
  lib,
  unstable,
  stateVersion,
  ...
} @ inputs: let
  # dags = lib.hm.dag;
  b = builtins;

  confFunc = home-manager.lib.homeManagerConfiguration;

  apps = import ./apps.nix inputs;
  git = import ./git.nix inputs;
  java = import ./java.nix inputs;
  guile = import ./guile.nix inputs;
  python = import ./python.nix inputs;
in rec {
  inherit confFunc;
  inherit apps git java guile python;

  # TODO cron here, because it isn't available
  # somehow, no idea how hard this will be

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

  dirMode = "750";
  createDir = n: ''
    mkdir -p $HOME/${n}
    chmod ${dirMode} $HOME/${n}
  '';
  createDirs = l: b.concatStringsSep "\n" (map createDir l);
}
