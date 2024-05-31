# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  # name,
  # stateVersion,
  # utils,
  ...
}: let
  # dags = lib.hm.dag;
  # b = builtins;
  # dots = "${dotfiles}";
  normalPackages = with pkgs; [];
  unstablePackages = with unstable; [];
in {
  home = {
    file = {
      ".config/nvim" = {
        recursive = true;
        source = "${dotfiles}/.config/nvim-server";
        force = true;
      };
      ".p10k.zsh" = {
        recursive = true;
        source = "${dotfiles}/.p10k-server.zsh";
        force = true;
      };
    };

    activation = {};

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
