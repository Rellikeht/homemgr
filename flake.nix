# vim: set et sw=2 ts=2:
{
  description = "Home Manager configuration of michal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:Rellikeht/dotfiles";
      flake = false;
    };

    my-builds.url = "github:Rellikeht/nix-builds";

    # dhallPrelude = {
    #   url = "https://prelude.dhall-lang.org/v22.0.0/package.dhall";
    #   flake = false;
    #   type = "file";
    # };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    dotfiles,
    my-builds,
    # dhallPrelude,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # {{{ defs
      b = builtins;
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      unstable = nixpkgs-unstable.legacyPackages.${system};
      builds = my-builds.packages.${system};
      stateVersion = "24.05";
      # }}}

      utils =
        # {{{
        import ./utils/utils.nix
        {
          inherit
            lib
            pkgs
            unstable
            home-manager
            dotfiles
            stateVersion
            ;
        };
      # }}}

      homeDConf = (
        # {{{
        name: homeDir: mods:
          utils.confFunc {
            inherit pkgs lib;
            modules = mods;
            extraSpecialArgs = {
              inherit dotfiles utils;
              inherit unstable builds;
              inherit name homeDir stateVersion;
              # inherit dhallPrelude;

              pythonProv = pkgs.python311;
              luaProv = pkgs.lua54;
            };
          }
      );
      # }}}

      homeConf = name: mods: homeDConf name "" mods;
      testConf = mods: homeDConf "test" "" mods;
    in {
      packages.homeConfigurations =
        {
          # Because systemd can't be assured and
          # home manager may not be so useful with it
          # it has to be used carefully

          # TODO Packages files, that may be super hard
          # TODO at the end activation should land here
          # TODO procedural creation ???

          # {{{ tests
          "testMinimal" = testConf [
            ./common.nix
            ./commonLinks.nix
            ./specific/server.nix

            ./code/pythonMinimal.nix
            ./code/minimal.nix
            ./code/normal.nix
            ./code/links.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/links.nix
            ./user/gits.nix
          ];

          "testGlinks" = testConf [
            ./common.nix
            ./code/minimal.nix
            ./code/normal.nix
            ./specific/common.nix

            ./server/minimal.nix
            ./server/user.nix
            ./user/gits.nix
            ./user/gitLinks.nix
          ];

          "testUser" = testConf [
            ./common.nix
            ./commonLinks.nix
            ./specific/common.nix

            ./code/pythonMinimal.nix
            ./code/minimal.nix
            ./code/normal.nix
            ./code/full.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/links.nix
            ./user/gits.nix
          ];

          "testServer" = testConf [
            ./common.nix
            ./commonLinks.nix
            ./specific/common.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/minecraft.nix

            ./code/pythonScraping.nix
          ];

          "testDev" = testConf [
            ./common.nix
            ./specific/common.nix

            ./user/gits.nix
            ./user/gitLinks.nix

            ./server/minimal.nix
            ./server/user.nix

            ./code/minimal.nix
            ./code/normal.nix
            ./code/full.nix
            ./code/pythonFull.nix
          ];

          # }}}
        }
        # {{{ simple server
        // (let
          files = [
            ./common.nix
            ./commonLinks.nix
            ./specific/server.nix
            ./code/links.nix
            ./server/minecraft.nix
          ];
        in {
          "simpleServer" = homeConf "server" files;

          "userSimpleServer" = homeConf (b.getEnv "USER") files;
          "homeSimpleServer" = homeConf "server" (b.getEnv "HOME") files;
          "userHomeSimpleServer" =
            homeConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;
        })
        # }}}
        # {{{ simple root
        // (let
          files = [
            ./common.nix
            ./commonLinks.nix
            ./specific/root.nix
            ./code/minimal.nix
            ./code/links.nix
          ];
        in {
          "simpleRoot" = homeDConf "root" "/root" files;

          "userSimpleRoot" = homeDConf (b.getEnv "USER") files;
          "homeSimpleRoot" = homeDConf "root" (b.getEnv "HOME") files;
          "userHomeSimpleRoot" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;
        })
        # }}}
        # {{{ server
        // (let
          files = [
            ./common.nix
            ./commonLinks.nix
            ./specific/common.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/links.nix
            ./code/minimal.nix
            ./code/links.nix
          ];
        in {
          "michalServer" = homeConf "michal" files;
          "server" = homeConf "server" files;

          "userServer" = homeConf (b.getEnv "USER") files;
          "homeMichalServer" = homeConf "michal" (b.getEnv "HOME") files;
          "userHomeServer" =
            homeConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;
        })
        # }}}
        # {{{ nix droid
        // (let
          # ocaml-lsp dependency build fails
          # because build instructions are fucked
          files = [
            ./common.nix
            ./commonLinks.nix
            ./specific/common.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/links.nix

            ./code/minimal.nix
            ./code/links.nix
            ./code/normal.nix
            ./code/pythonMinimal.nix
          ];

          pkgfiles = [
            ./pkgs/common.nix
            ./pkgs/codeMinimal.nix
            ./pkgs/codeNormal.nix
          ];
        in {
          "nixDroidDev" = homeConf "nix-on-droid" files;
          "testDroidDev" = homeConf "test" files;
          "testDroidDevPkgs" = homeConf "test" (
            files ++ pkgfiles
          );

          "userNixDroidDev" = homeConf (b.getEnv "USER") files;
          "nixDroidDevPkgs" = homeConf "nix-on-droid" (
            files ++ pkgfiles
          );
          "usernixDroidDevPkgs" = homeConf (b.getEnv "USER") (
            files ++ pkgfiles
          );
        })
        # }}}
        ;
      # // (let
      # in {
      # })

      inherit utils;
    });
}
