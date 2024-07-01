# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  # dotfiles,
  # name,
  # homeDir ? "",
  # stateVersion,
  utils,
  packed,
  ... # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  # b = builtins;
  # dots = "${dotfiles}";
  # }}}
  normalPackages = with pkgs; [
    # {{{
    shellcheck
    checkbashisms

    alejandra
    nil

    silver-searcher # just in case

    dash # just in case

    moreutils # ??

    # there is an home manager option,
    # but i configured it manually in rc files
    z-lua

    glow
    timer

    jq
    delta
    rlwrap # just in case

    (lib.setPrio 100 packed.python.pythonSimple)
    ocaml # ??

    aria2 # just in case
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
  ]; # }}}

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
          + utils.apps.vimUp "${pkgs.neovim}/bin/nvim"
          + ''
            unlink "$HOME/bin/svim"
          ''
        );
    }; # }}}

    # {{{
    packages = normalPackages ++ unstablePackages;
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
      enable = true;
      package = pkgs.gitFull;

      aliases = {};
      attributes = [];
      extraConfig = {};

      hooks = {};
      includes = [];
      ignores = commonIgnores;

      delta = {
        enable = true;
        package = pkgs.delta;
        options = {};
      };
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

  # fzf = {
  #   # {{{
  #   enable = true;
  #   package = fzfPackage;
  #   enableBashIntegration = true;
  #   enableZshIntegration = true;
  # }; # }}}

  # TODO
  # nix = {
  #   # {{{
  #   # package = pkgs.nix;

  #   # channels = {
  #   #   # {{{
  #   #   inherit pkgs unstable;
  #   # }; # }}}

  #   nixPath = [
  #     # {{{
  #     "$HOME/.nix-defexpr/channels"
  #   ]; # }}}

  #   settings = {
  #     # {{{
  #     use-sandbox = true;
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
}
