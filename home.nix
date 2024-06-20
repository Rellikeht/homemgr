# vim: set et sw=2 ts=2:
{
  # {{{
  lib,
  dotfiles,
  name,
  homeDir ? "",
  stateVersion,
  utils,
  ... # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
  defHomeDir = "/home/${name}";
  homeDirectory =
    if homeDir == ""
    then defHomeDir
    else homeDir;
  # }}}
in {
  home = {
    # {{{
    inherit homeDirectory stateVersion;
    username = name;
    # }}}
  };

  home-manager = {
    # {{{
    # Let Home Manager install and manage itself.
    enable = true;
  }; # }}}

  news.display = "silent";
}
