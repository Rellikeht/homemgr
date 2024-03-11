# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
}: let
  dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";

  normalPackages = with pkgs; [];
  unstablePackages = with unstable; [];
  jdks = with pkgs; [];
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        ".screenrc"
      ])
      // b.listToAttrs (utils.configDirs [
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "nim"
      ]);

    sessionVariables = {
    };

    activation = {
      codeDirs = dags.entryAfter ["writeBoundary"] (
        (utils.createDirs [])
        + ''
        ''
      );

      codeBins =
        dags.entryAfter ["commonBins"] ''
        '';
    };

    packages = normalPackages ++ unstablePackages ++ jdks;
  };
}
