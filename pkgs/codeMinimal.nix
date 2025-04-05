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
  b = builtins;
  dots = "${dotfiles}";

  normalPackages = with pkgs; [
    sqlite-interactive
    pdfgrep
    binutils
  ];

  unstablePackages = with unstable; [
  ];
in {
  home = {
    packages = normalPackages ++ unstablePackages;
  };

  programs = {
    # {{{
    neovim = {
      # {{{
      extraLuaPackages = ps:
        with ps; [
          # {{{
          magick
        ]; # }}}

      extraPackages = with pkgs; [
        # {{{
        imagemagick
      ]; # }}}

      extraPython3Packages = ps:
        with ps; [
          # {{{
          jupyter-client
          # cairosvg # for image rendering
          # pnglatex # for image rendering
          # plotly # for image rendering
          # pyperclip
        ]; # }}}
    }; # }}}
  }; # }}}
}
