# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  # old,
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
    ]) # }}}
    ++ (with haskellPackages; [
      # {{{
    ])); # }}}
  # oldPackages = with old; [
  #   # {{{
  #   # ocamlPackages.ocaml-lsp
  # ]; # }}}
in {
  home = {
    file =
      {
        # {{{
        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.p10k-droid.zsh";
          force = true;
        }; # }}}

        ".prompt.bash" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.prompt-droid.bash";
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
