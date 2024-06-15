# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  # lib,
  dotfiles,
  # name,
  utils,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  # }}}

  normalPackages = with pkgs; (
    [
      # {{{
    ] # }}}
    ++ (with lua54Packages; [
      # {{{
    ]) # }}}
    ++ (with ocamlPackages; [
      # {{{
      ocaml-lsp
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
        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.p10k-root.zsh";
          force = true;
        }; # }}}

        ".prompt.bash" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.prompt-root.bash";
          force = true;
        }; # }}}
      } # }}}
      // b.listToAttrs (utils.configFiles [
        # {{{
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
