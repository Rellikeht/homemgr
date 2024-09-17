# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  utils,
  packed,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  python = packed.python;
  # }}}

  guile-libs = with pkgs; [
    # {{{
  ]; # }}}

  normalPackages = with pkgs; (
    [
      # {{{
      gallery-dl
      (python.pythonScraping // {meta.priority = 8;})
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ]) # }}}
  );

  unstablePackages = with unstable; ([
      # {{{
    ] # }}}
    ++ (with ocamlPackages; [
      # {{{
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ])); # }}}
in {
  home = {
    packages =
      normalPackages
      ++ unstablePackages
      ++ python.normalPackages
      ++ python.unstablePackages
      ++ python.addNormalPackages
      ++ python.addUnstablePackages
      ++ guile-libs;
  };
}
