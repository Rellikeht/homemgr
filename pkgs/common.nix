# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  builds,
  lib,
  # dotfiles,
  # name,
  # stateVersion,
  utils,
  packed,
  ...
  # }}}
}: let
  # {{{
  b = builtins;
  dags = lib.hm.dag;
  # }}}

  normalPackages = with pkgs; [
    # {{{
    gnused
    gnugrep
    gawk
    bc
    ed
    coreutils-full
    which

    gnutar
    gzip
    xz
    pixz
    bzip2

    zip
    unzip

    diffutils
    gnupatch
    (lib.setPrio 200 gcc)
    gnumake
    binutils
    glibc
    iconv
    file
    time

    inetutils
    rsync
    openssh
    w3m

    findutils
    plocate
    pdfgrep
    tre

    util-linux
    su
    sudo

    highlight
    imagemagick
    sqlite-interactive
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
    vifm-full
    # dash
  ]; # }}}

  lua =
    # {{{
    with packed.lua; (
      [
        # {{{
        (lib.setPrio 150 luaP)
        (lib.setPrio 100 luajitP)
        # }}}
      ]
      ++ luaMinPkgs
      ++ luaMinUnstablePkgs
      ++ luaNormalPkgs
      ++ luaUnstablePkgs
    ); # }}}

  python = with packed.python; ( # {{{
    normalPkgs
    ++ unstablePkgs
    ++ [
      # {{{
      (lib.setPrio 200 pythonSimple)
    ] # }}}
  );
  # }}}

  myBuilds = with builds; [
    # {{{
    svim
  ]; # }}}
in {
  home = {
    file =
      {
        # {{{
      } # }}}
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

      updatePath =
        dags.entryAfter ["writeBoundary"]
        # {{{
        ''
          export PATH="$PATH:$HOME/bin:$HOME/.nix-profile/bin"
        '';
      # }}}

      vimUpPrep =
        dags.entryBefore ["vimUpdate"]
        # {{{
        ''
          export PATH="$PATH:${pkgs.gcc}/bin/"
        '';
      # }}}

      opamActivation =
        dags.entryAfter ["installPackages"]
        # {{{
        ''
          export PATH="$PATH:${pkgs.gitFull}/bin"
          export PATH="$PATH:${pkgs.mercurialFull}/bin:${pkgs.rsync}/bin"
          export PATH="$PATH:${pkgs.rsync}/bin"
          export PATH="$PATH:${pkgs.gcc}/bin"
          export PATH="$PATH:${pkgs.gnumake}/bin"
          export PATH="$PATH:${pkgs.gnutar}/bin"
          export PATH="$PATH:${pkgs.gzip}/bin"
          export PATH="$PATH:${pkgs.diffutils}/bin"
          export PATH="$PATH:${pkgs.gnupatch}/bin"

          ${unstable.opam}/bin/opam init --no
        '';
      # }}}
    }; # }}}

    packages =
      normalPackages
      ++ unstablePackages
      ++ lua
      ++ python
      ++ myBuilds;
  };

  programs = {
    bash = {
      # {{{
      enable = true;
      enableCompletion = true;

      shellOptions = [
        # {{{
      ]; # }}}

      sessionVariables = {
        # {{{
      }; # }}}

      initExtra =
        # {{{
        ''
          source "$HOME/.user.bashrc"
        '';
      # }}}
    }; # }}}

    zsh = {
      # {{{

      # {{{
      enable = true;
      package = unstable.zsh;
      enableCompletion = true;
      defaultKeymap = "emacs";
      # }}}

      syntaxHighlighting = {
        # {{{
        enable = true;
        package = unstable.zsh-syntax-highlighting;
        # TODO settings
      }; # }}}

      sessionVariables = {
        # {{{
      }; # }}}

      initExtra =
        # {{{
        ''
          source ${unstable.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source "$HOME/.user.zshrc"
        ''; # }}}
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

      # It is in dotfiles already
      enableBashIntegration = false;
      enableZshIntegration = false;
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

      extraPackages = with pkgs; [
        # {{{
      ]; # }}}

      extraLuaPackages = ps:
        with ps; [
          # {{{
        ]; # }}}

      extraPython3Packages = ps:
        with ps; [
          # {{{
          pynvim
        ]; # }}}
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
