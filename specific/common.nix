# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  # lib,
  # dotfiles,
  # name,
  minimized,
  utils,
  ...
  # }}}
}: let
  b = builtins;

  normalPackages = with pkgs; (
    [
      # {{{
    ] # }}}
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
        ".config/nvim" = {
          # {{{
          recursive = true;
          source = "${minimized}/.config/nvim";
          force = true;
        }; # }}}
      } # }}}
      // b.listToAttrs (utils.configFiles [
        # {{{
        ".p10k.zsh"
        ".prompt.bash"
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

    packages = normalPackages ++ unstablePackages;
  };
}
