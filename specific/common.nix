# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  # lib,
  # dotfiles,
  # name,
  utils,
  ...
  # }}}
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
      # ocaml-lsp
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
    file =
      {
        # {{{
      } # }}}
      // b.listToAttrs (utils.configFiles [
        # {{{
        ".p10k.zsh"
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
        "nvim"
      ]); # }}}

    activation = {
      # {{{
    }; # }}}

    packages = normalPackages ++ unstablePackages;
  };
}
