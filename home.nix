# vim: set et sw=2 ts=2:
{
  # {{{
  name,
  homeDir ? "",
  stateVersion,
  # lib,
  # dotfiles,
  # utils,
  ... # }}}
}: let
  # {{{
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

  programs = {
    home-manager = {
      # {{{
      # Let Home Manager install and manage itself.
      enable = true;
    }; # }}}
  };

  news.display = "silent";
}
