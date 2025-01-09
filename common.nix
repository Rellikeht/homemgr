# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  utils,
  # dotfiles,
  # packed,
  ... # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  # b = builtins;
  # dots = "${dotfiles}";
  # }}}

  # mparallel = ( # {{{
  #   pkgs.writeScriptBin
  #   "mparallel"
  #   ''exec ${pkgs.moreutils}/bin/parallel $@''
  # ); # }}}

  normalPackages = with pkgs; [
    # {{{
    shellcheck
    alejandra
    silver-searcher # just in case

    dash # just in case
    fdupes
    (parallel // {meta.priority = 9;})
    # mparallel
    tldr

    # there is an home manager option,
    # but i configured it manually in rc files
    z-lua
    glow

    jq
    delta
    rlwrap # just in case
    ocaml # ??
    aria2 # just in case
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
    universal-ctags
  ]; # }}}

  additional = [
    (pkgs.writeScriptBin "egrep" ''
      exec grep -E $@
    '')
    (pkgs.writeScriptBin "fgrep" ''
      exec grep -F $@
    '')
  ];

  fzfPackage = unstable.fzf;
in {
  home = {
    sessionVariables = {
      # {{{
      FZF_STARTUP_LOCATION = "${fzfPackage}";
    }; # }}}

    activation = {
      # {{{

      vimUpdate =
        dags.entryAfter ["commonBinLinks"]
        (
          utils.apps.vimUpPrep
          + utils.apps.vimUp ''"$HOME/bin/svim"''
          + utils.apps.vimUp "${unstable.neovim}/bin/nvim"
          + ''
            unlink "$HOME/bin/svim"
          ''
        );
    }; # }}}

    # {{{
    packages = normalPackages ++ unstablePackages ++ additional;
    # }}}
  };

  programs = let
    commonIgnores = [
      # {{{
      "*~"
      "*.swp"
      ".direnv"
      "*cache*/"
    ]; # }}}
  in {
    direnv = {
      # {{{
      enable = true;
      nix-direnv.enable = true;

      # It is in dotfiles already
      enableBashIntegration = false;
      enableZshIntegration = false;
    }; # }}}

    git = {
      # {{{
      enable = false;
      package = pkgs.gitFull;

      aliases = {};
      attributes = [];
      extraConfig = {};

      hooks = {};
      includes = [];
      ignores = commonIgnores;

      delta = {
        #  {{{
        enable = true;
        package = pkgs.delta;
        options = {};
      }; #  }}}
    }; # }}}

    mercurial = {
      # {{{
      enable = true;
      package = pkgs.mercurialFull;

      # :(
      # userName = "Rellikeht";
      userName = "";
      userEmail = "";

      aliases = {};
      extraConfig = {};
      ignores = commonIgnores;
    }; # }}}
  };

  # nix = {
  #   # {{{
  #   # package = pkgs.nix;

  #   # Stable home manager ?
  #   # channels = {
  #   #   # {{{
  #   #   inherit pkgs unstable;
  #   # }; # }}}

  #   # nixPath = [
  #   #   # {{{
  #   #   "$HOME/.nix-defexpr/channels"
  #   # ]; # }}}

  #   extraOptions =
  #     # {{{
  #     ''
  #     ''; # }}}

  #   settings = {
  #     # {{{
  #     show-trace = true;
  #   }; # }}}

  #   registry = {
  #     # {{{
  #     homemgr = {
  #       # {{{
  #       from = {
  #         id = "homemgr";
  #         type = "indirect";
  #       };

  #       to = {
  #         owner = "Rellikeht";
  #         repo = "homemgr";
  #         type = "gitlab";
  #       };
  #     }; # }}}

  #     builds = {
  #       # {{{
  #       from = {
  #         id = "builds";
  #         type = "indirect";
  #       };

  #       to = {
  #         owner = "Rellikeht";
  #         repo = "nix-builds";
  #         type = "gitlab";
  #       };
  #     }; # }}}

  #     environments = {
  #       # {{{
  #       from = {
  #         id = "environments";
  #         type = "indirect";
  #       };

  #       to = {
  #         owner = "Rellikeht";
  #         repo = "environments";
  #         type = "gitlab";
  #       };
  #     }; # }}}
  #   }; # }}}

  #   checkConfig = true;
  # }; # }}}

  nixpkgs = {
    # {{{

    config = {
      # {{{
      allowUnfree = true;
    }; # }}}

    overlays = [];
  }; # }}}
}
