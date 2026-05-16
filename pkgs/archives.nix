# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  # lib,
  # dotfiles,
  # name,
  # stateVersion,
  # utils,
  ...
  # }}}
}: let
  normalPackages = with pkgs; [
    # {{{
    fuse-archive
    rar2fs
    fuseiso
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
  ]; # }}}
in {
  home = {
    packages = normalPackages ++ unstablePackages;
  };
}
