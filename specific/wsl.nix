# vim: set et sw=2 ts=2:
{
  # {{{
  # config,
  pkgs,
  unstable,
  # lib,
  dotfiles,
  utils,
  ...
  # }}}
}: let
  # {{{
  # dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; (
    [
      # {{{
    ] # }}}
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
        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.p10k-wsl.zsh";
          force = true;
        }; # }}}

        ".prompt.bash" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.prompt-wsl.bash";
          force = true;
        }; # }}}
      }
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

    sessionVariables = {
      # {{{
    }; # }}}

    packages = normalPackages ++ unstablePackages;
  };
}
