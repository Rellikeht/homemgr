# vim: set et sw=2 ts=2:
{
  # {{{
  config,
  pkgs,
  unstable,
  packed,
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

  normalPackages = with pkgs; [
    # {{{
    (packed.python.pythonEssential // {meta.priority = 11;})
    timer
    ripgrep-all
    pdfgrep
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
    typst
    typst-lsp
    typstfmt
    typst-live

    # TODO B pandoc
  ]; # }}}
in {
  home = {
    file = {};

    activation = {};

    sessionVariables = {};

    packages = normalPackages ++ unstablePackages;
  };
}
