# vim: set et sw=2 ts=2:
{
  # {{{
  config,
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
  # mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
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
        # {{{
        ".p10k.zsh" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.p10k-tablet.zsh";
          force = true;
        }; # }}}

        ".prompt.bash" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/.prompt-tablet.bash";
          force = true;
        }; # }}}

        # TODO sd cart I guess
        # "storage" = {
        #   source = mkOutOfStoreSymlink /storage/emulated/0;
        #   force = true;
        # };
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
