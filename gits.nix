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

  homeDirectory = "/home/${name}";
in {
  home = {
    file = {};

    activation = {
      gits =
        dags.entryAfter ["dirs"]
        (b.concatStringsSep "\n"
          (map utils.cloneMyGithub [
            {
              parent = "";
              name = "nix-config";
            }
          ]));
    };

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
