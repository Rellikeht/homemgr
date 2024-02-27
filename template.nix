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

  normalPackages = with pkgs; [];
  unstablePackages = with unstable; [];
  jdks = with pkgs; [];

  homeDirectory = "/home/${name}";
in {
  packages = normalPackages ++ unstablePackages ++ jdks;

  file =
    {}
    // b.listToAttrs (utils.configFiles [
      ".alacritty.toml"
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
    dirs =
      dags.entryAfter ["writeBoundary"]
      (utils.createDirs [])
      + ''
      '';

    bins =
      dags.entryAfter ["commonBins"] ''
      '';
  };
}
