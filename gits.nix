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

  normalPackages = with pkgs; [
    git
  ];

  unstablePackages = with unstable; [];

  homeDirectory = "/home/${name}";
in {
  home = {
    file = {};

    activation = {
      gits =
        dags.entryAfter ["dirs"]
        (
          b.concatStringsSep "\n" (
            (utils.cloneGithubs "configs" [
              "nix-config"
              "dotfiles"
            ])
            ++ (
              utils.cloneGithubs "programs" [
                "nix-builds"
                "st"
                "dwm"
                "tabbed"
                "dmenu"
                "dmenu"
              ]
            )
            ++ (
              utils.cloneGitlabs "configs" [
                "homemgr"
              ]
            )
          )
        );
    };

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
