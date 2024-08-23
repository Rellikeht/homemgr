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

  # {{{ TODO
  # zathura:
  # - works with default config (maybe some little things)
  # - for some reason this makes it not crash wildly:
  #   alias zathura='zathura -P 0'
  # mpv config:
  # - make launching work,  running vlc before it makes it work,
  #   probably xorg compatibility is a reason
  # - touch control (middle button ?)
  # vlc config:
  # - no metadata question, what a fucking idiot invented it
  # - mpv like bindings
  # - touch control like will be in mpv
  # maybe some pinta :)
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
          source = "${dotfiles}/p10ks/tablet.zsh";
          force = true;
        }; # }}}

        ".prompt.bash" = {
          # {{{
          recursive = true;
          source = "${dotfiles}/prompts/tablet.bash";
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
