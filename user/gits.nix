# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
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
    # gitFull
  ];

  unstablePackages = with unstable; [
  ];
  # homeDirectory = "/home/${name}";
in {
  home = {
    activation = {
      gits =
        dags.entryAfter ["commonBins"]
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
                "svim-comptools"
              ]
            )
            ++ (
              utils.cloneGithubs "random" [
                "advent-of-code"
                "moderncv.typst"
                "project_euler"
                "Random-code"
                "zadanka"
              ]
            )
            ++ (
              utils.cloneGitlabs "configs" [
                "homemgr"
              ]
            )
          )
          + ''
          ''
        );
    };

    packages = normalPackages ++ unstablePackages;
  };
}
