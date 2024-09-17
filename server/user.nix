# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  builds,
  lib,
  utils,
  packed,
  ...
  # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  # b = builtins;
  # dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; (
    [
      # {{{
      pkgtop

      phodav
      cadaver

      (moreutils // {meta.priority = 10;})
      timer
      ripgrep-all
    ] # }}}
  );

  unstable_packages = with unstable; [
    # {{{

    nim
    nimlsp
    # nimble

    #
  ]; # }}}

  myBuilds = with builds; [
    # {{{
  ]; # }}}

  lua =
    # {{{
    with packed.lua; (
      [
        # {{{
        (luaP // {meta.priority = 9;})
        (luajitP // {meta.priority = 10;})
        # }}}
      ]
      ++ luaMinPkgs
      ++ luaMinUnstablePkgs
    ); # }}}

  java = with pkgs; [
    # {{{
    (jre_minimal // {meta.priority = 7;})
  ]; # }}}
  # homeDirectory = "/home/${name}";
in {
  home = {
    file =
      {
        # {{{
      } # }}}
      // (utils.java.javaNamePaths java);

    sessionVariables =
      {
        # {{{
        # why the fuck doesn't this work??
        # PATH = "$PATH:${homeDirectory}/bin";
        # Maybe...
        # PATH = "$PATH:$HOME/bin";
      } # }}}
      // (utils.java.javaNameVars java);

    activation = {
      # {{{
      userServerDirs = dags.entryAfter ["serverDirs"] (
        (utils.createDirs [
          ])
        + ''
        ''
      );

      userServerBins =
        dags.entryAfter ["commonBins"] ''
        '';
    }; # }}}

    packages =
      normalPackages
      ++ unstable_packages
      ++ java
      ++ lua
      ++ myBuilds;
  };

  programs = {
    yt-dlp = {
      # {{{
      enable = true;
      package = unstable.yt-dlp;
      extraConfig = "";
      settings = {};
    }; # }}}
  };
}
