# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  builds,
  # lib,
  # dotfiles,
  # name,
  # stateVersion,
  # utils,
  ...
}: let
  # b = builtins;
  normalPackages = with pkgs; [
    gnused
    gnugrep
    gawk
    bc
    ed
    coreutils-full
  ];

  unstablePackages = with unstable; [
    lua
    luajit
    vifm-full

    dash
  ];
in {
  home = {
    packages = normalPackages ++ unstablePackages;
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };

    zsh = {
      enable = true;
      package = unstable.zsh;
      enableCompletion = true;
      defaultKeymap = "emacs";

      syntaxHighlighting = {
        enable = true;
        package = unstable.zsh-syntax-highlighting;
        # TODO settings
      };

      # Hope this will work
      initExtra = ''
        source ${unstable.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };

    tmux = {
      enable = true;
      package = pkgs.tmux;
      aggresiveResize = false;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 262144;
      mouse = true;
      keyMode = "vi";
      prefix = null;

      extraConfig = let
        prefix = "M-Space";
      in ''
        unbind C-b
        unbind "${prefix}"
        set -g prefix "${prefix}"
        bind "${prefix}" send-prefix
      '';
    };

    fzf = {
      enable = true;
      package = unstable.fzf;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    neovim = {
      enable = true;
      package = unstable.neovim-unwrapped;
    };

    vim = {
      enable = true;
      package = builds.svim;
      # defaultEditor = true;
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
        prettybat
      ];
    };

    readline = {
      enable = true;
      bindings = {};
      extraConfig = "";
      includeSystemConfig = true;
      variables = {};
    };

    htop = {
      # TODO
      enable = true;
      package = unstable.htop;
      settings = {};
    };
  };
}
