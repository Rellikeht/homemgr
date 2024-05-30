# vim: set et sw=2 ts=2:
{
  # config,
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
  # dots = "${dotfiles}";
  normalPackages = with pkgs; [
    gnused
    gnugrep

    tmux
  ];

  unstablePackages = with unstable; [
    lua
    luajit

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
  };
}
