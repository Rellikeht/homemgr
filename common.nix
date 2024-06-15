# vim: set et sw=2 ts=2:
{
  # {{{
  pkgs,
  unstable,
  lib,
  dotfiles,
  name,
  homeDir ? "",
  stateVersion,
  utils,
  ... # }}}
}: let
  # {{{
  dags = lib.hm.dag;
  b = builtins;
  dots = "${dotfiles}";
  # }}}

  normalPackages = with pkgs; [
    # {{{
    shellcheck
    checkbashisms

    alejandra
    silver-searcher
    dash

    glow
    nil
    jq
    delta
    rlwrap

    (lib.setPrio 100 python313)
    ocaml

    aria2
  ]; # }}}

  unstablePackages = with unstable; [
    # {{{
  ]; # }}}

  # {{{
  defHomeDir = "/home/${name}";
  homeDirectory =
    if homeDir == ""
    then defHomeDir
    else homeDir;
  # }}}

  fzfPackage = unstable.fzf;
in {
  home = {
    sessionVariables = {
      # {{{
      FZF_STARTUP_LOCATION = "${fzfPackage}";
    }; # }}}

    activation = {
      # {{{
      commonDirs =
        dags.entryAfter ["writeBoundary"]
        (
          ''
          ''
          + (utils.createDirs [
            "bin"
            ".local/run"
          ])
          + ''
            chmod 750 $HOME
          ''
        );

      # commonBins = dags.entryAfter ["installPackages"] ''
      commonBins = dags.entryAfter ["commonDirs"] ''
        find "$HOME/bin" -type l -delete || true
        ln -s "${pkgs.gnugrep}/bin/grep" "${homeDirectory}/bin/its_just_grep"
      '';
    }; # }}}

    # {{{
    inherit homeDirectory stateVersion;
    username = name;
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
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    direnv = {
      # {{{
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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

  news.display = "silent";
}
