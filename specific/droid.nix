# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  old,
  # lib,
  # dotfiles,
  # name,
  utils,
  ...
}: let
  b = builtins;

  normalPackages = with pkgs; (
    [
      # {{{
    ] # }}}
    ++ (with lua54Packages; [
      # {{{
    ]) # }}}
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
      # FUCK
      # lsp
      # ocaml-lsp
      # utop
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ])); # }}}

  oldPackages = with old; [
    # {{{
    ocamlPackages.ocaml-lsp
  ]; # }}}
in {
  home = {
    file =
      {
        # {{{
      } # }}}
      // b.listToAttrs (utils.configFiles [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
      ]); # }}}

    activation = {
      # {{{
    }; # }}}

    packages =
      normalPackages
      ++ unstablePackages
      ++ oldPackages;
  };
}
