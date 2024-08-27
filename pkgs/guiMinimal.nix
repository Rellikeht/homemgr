# vim: set et sw=2 ts=2:
{
  # {{{
  config,
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  stateVersion,
  utils,
  ...
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
  # }}}

  # {{{ TODO
  # browsers
  # }}}

  normalPackages = with pkgs; [
    # {{{
    mupdf
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
  ]; # }}}
in {
  home = {
    # {{{
    packages = normalPackages ++ unstablePackages;
  }; # }}}

  programs = {
    # {{{

    mpv = {
      # {{{
      enable = true;

      package = with pkgs; (wrapMpv (
          mpv-unwrapped.override {
            # vapoursynthSupport = true;
          }
        ) {
          youtubeSupport = true;
        });

      config = {
        # {{{
      }; # }}}

      bindings = {
        # {{{
      }; # }}}

      profiles = {
        # {{{
      }; # }}}

      scripts = with pkgs.mpvScripts; [
        # {{{
        # TODO B more I guess
        mpris
        quality-menu
      ]; # }}}

      scriptOpts = {
        # {{{
      }; # }}}
    }; # }}}
  }; # }}}
}
