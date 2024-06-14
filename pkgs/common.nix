# vim: set et sw=2 ts=2:
{
  pkgs,
  unstable,
  builds,
  # lib,
  # dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
}: let
  b = builtins;

  normalPackages = with pkgs; [
    # {{{
    gnused
    gnugrep
    gawk
    bc
    ed
    coreutils-full
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
    (lib.setPrio 150 lua)
    luajit
    vifm-full

    dash
  ]; # }}}

  myBuilds = with builds; [
    svim
  ];
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configDirs [
        # {{{
      ]) # }}}
      // b.listToAttrs (utils.configCDirs [
        # {{{
      ]);
    # }}}

    activation = {
      # {{{
    }; # }}}

    packages = normalPackages ++ unstablePackages ++ myBuilds;
  };

  programs = {
    bash = {
      # {{{
      enable = true;
      enableCompletion = true;

      initExtra = ''
        source "$HOME/.user.bashrc"
      '';
    }; # }}}

    zsh = {
      # {{{
      enable = true;
      package = unstable.zsh;
      enableCompletion = true;
      defaultKeymap = "emacs";

      syntaxHighlighting = {
        enable = true;
        package = unstable.zsh-syntax-highlighting;
        # TODO settings
      };

      initExtra = ''
        source ${unstable.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source "$HOME/.user.zshrc"
      '';
    }; # }}}

    tmux = {
      # {{{
      enable = true;
      package = pkgs.tmux;
      aggressiveResize = false;
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
    }; # }}}

    fzf = {
      # {{{
      enable = true;
      package = unstable.fzf;
      enableBashIntegration = true;
      enableZshIntegration = true;
    }; # }}}

    neovim = {
      # {{{
      enable = true;
      package = unstable.neovim-unwrapped;
      defaultEditor = false;
      coc.enable = false;

      extraConfig = '''';
      extraLuaConfig = '''';
      # extraWrapperArgs = [];

      extraPackages = with pkgs; [];
      extraLuaPackages = ps: with ps; [];
      extraPython3Packages = ps:
        with ps; [
          pynvim
        ];
    }; # }}}

    vim = {
      # {{{
      # It is done in packages :(
      enable = false;
      # packageConfigurable = builds.svim;
      defaultEditor = true;

      # This be needed, but just in case...
      extraConfig = '''';
      settings = {
        background = "dark";
        history = 2000;
        modeline = false;
        expandtab = true;
        shiftwidth = 4;
        tabstop = 4;
        number = true;
        relativenumber = true;
        mouse = "a";
        smartcase = true;
      };
    }; # }}}

    bat = {
      # {{{
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
        prettybat
      ];
    }; # }}}

    readline = {
      # {{{
      enable = true;
      bindings = {};
      extraConfig = "";
      includeSystemConfig = true;
      variables = {};
    }; # }}}

    htop = {
      # {{{
      # TODO
      enable = true;
      package = unstable.htop;
      settings = {};
    }; # }}}
  };
}
