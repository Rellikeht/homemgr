# vim: set et sw=2 ts=2:
{
  description = "Home Manager configuration of michal";

  inputs = {
    # {{{ pkgs

    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-old.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # }}}

    # {{{ my

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

    # }}}
  };

  outputs = {
    # {{{
    nixpkgs,
    nixpkgs-unstable,
    # nixpkgs-old,
    flake-utils,
    home-manager,
    dotfiles,
    my-builds,
    # dhallPrelude,
    ...
  }:
  # }}}
    flake-utils.lib.eachDefaultSystem (system: let
      # {{{ defs
      b = builtins;
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      unstable = nixpkgs-unstable.legacyPackages.${system};
      # old = nixpkgs-old.legacyPackages.${system};
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
            # old
            
            home-manager
            dotfiles
            stateVersion
            ;
        };
      # }}}

      packed =
        # {{{
        import ./packed/packed.nix
        {inherit pkgs unstable lib;};
      # }}}

      homeDConf = (
        # {{{
        name: homeDir: mods:
          utils.confFunc {
            inherit pkgs lib;
            modules = [./home.nix] ++ mods;
            extraSpecialArgs = {
              inherit dotfiles utils packed;
              inherit unstable builds;
              # inherit old;
              inherit name homeDir stateVersion;
              # inherit dhallPrelude;
            };
          }
      );
      # }}}

      # {{{
      homeConf = name: mods: homeDConf name "" mods;
      testConf = mods: homeDConf "test" "" mods;
      # }}}
    in {
      packages.homeConfigurations =
        {
          # TODO C procedural creation ???

          # {{{ tests
          # }}}
        }
        # {{{ shallow
        // (let
          files = [
            ./commonLinks.nix
            ./specific/shallow.nix
            ./code/links.nix
            ./server/links.nix
          ];

          name = "michal";
        in {
          "shallow" = homeConf name files;
          "userShallow" =
            homeConf
            (b.getEnv "USER")
            files;
          "homeShallow" =
            homeDConf
            name
            (b.getEnv "HOME")
            files;
          "userHomeShallow" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;

          "shallowUser" =
            homeConf
            name
            (files ++ [./user/links.nix]);
          "userShallowUser" =
            homeConf
            (b.getEnv "USER")
            (files ++ [./user/links.nix]);
          "homeShallowUser" =
            homeDConf
            name
            (b.getEnv "HOME")
            (files ++ [./user/links.nix]);
          "userHomeShallowUser" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            (files ++ [./user/links.nix]);
        })
        # }}}
        # {{{ simple root
        // (let
          files = [
            # {{{
            ./common.nix
            ./commonLinks.nix
            ./specific/root.nix
            ./code/minimal.nix
            ./code/links.nix
          ]; # }}}
        in {
          # {{{

          "simpleRoot" = homeDConf "root" "/root" files;
          "userSimpleRoot" = homeConf (b.getEnv "USER") files;
          "homeSimpleRoot" = homeDConf "root" (b.getEnv "HOME") files;
          "userHomeSimpleRoot" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;
        }) # }}}
        # }}}
        # {{{ simple server
        // (let
          files = [
            # {{{
            ./common.nix
            ./commonLinks.nix
            ./specific/server.nix
            ./code/links.nix
          ]; # }}}
          mfiles = files ++ [./server/minecraft.nix];

          name = "server";
        in {
          #

          "simpleServer" = homeConf name files;
          "userSimpleServer" = homeConf (b.getEnv "USER") files;
          "homeSimpleServer" = homeDConf name (b.getEnv "HOME") files;
          "userHomeSimpleServer" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;

          "minecraftServer" = homeConf name mfiles;
          "userMinecraftServer" = homeConf (b.getEnv "USER") mfiles;
          "homeMinecraftServer" = homeDConf name (b.getEnv "HOME") mfiles;
          "userHomeMinecraftServer" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            mfiles;
        })
        # }}}
        # {{{ TODO B wsl
        // (let
          files = [
            # {{{
            ./common.nix
            ./commonLinks.nix
            ./specific/wsl.nix
            ./code/links.nix
          ]; # }}}
        in {
          # {{{ simple
          "michalsimpleWsl" = homeConf "michal" files;
          "lamussimpleWsl" = homeConf "lamus" files;
          "userSimpleWsl" = homeConf (b.getEnv "USER") files;
          "homeMichalSimpleWsl" = homeDConf "michal" (b.getEnv "HOME") files;
          "homeLamusSimpleWsl" = homeDConf "lamus" (b.getEnv "HOME") files;
          "userHomeSimpleWsl" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;
          # }}}

          # TODO C full
        })
        # }}}
        # {{{ server
        // (let
          files = [
            # {{{
            ./common.nix
            ./commonLinks.nix
            ./specific/common.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/links.nix
            ./code/minimal.nix
            ./code/links.nix
          ]; # }}}
        in {
          #

          "michalServer" = homeConf "michal" files;
          "serverServer" = homeConf "server" files;
          "userServer" = homeConf (b.getEnv "USER") files;
          "homeMichalServer" =
            homeDConf "michal"
            (b.getEnv "HOME")
            files;
          "userHomeServer" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;

          "michalSserver" =
            homeConf "michal"
            (files ++ [./code/scraping.nix]);
          "serverSserver" =
            homeConf "server"
            (files ++ [./code/scraping.nix]);
          "userSserver" =
            homeConf (b.getEnv "USER")
            (files ++ [./code/scraping.nix]);
          "homeMichalSserver" =
            homeDConf "michal"
            (b.getEnv "HOME")
            (files ++ [./code/scraping.nix]);
          "userHomeSserver" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            (files ++ [./code/scraping.nix]);
        })
        # }}}
        # {{{ droid
        // (let
          # ocaml-lsp dependencies builds are failing
          # because build instructions are fucked
          # it needs access to root filesystem or something
          files = [
            # {{{
            ./common.nix
            ./commonLinks.nix
            ./specific/droid.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/links.nix

            ./code/minimal.nix
            ./code/links.nix
            ./code/normal.nix
          ]; # }}}

          pkgfiles = [
            # {{{
            ./pkgs/common.nix
            ./pkgs/links.nix
            ./pkgs/codeMinimal.nix
            ./pkgs/codeNormal.nix
          ]; # }}}

          name = "nix-on-droid";
        in {
          # {{{

          "nixDroidDev" =
            homeDConf
            name
            "/data/data/com.termux.nix/files/home"
            files;
          "userNixDroidDev" =
            homeDConf
            (b.getEnv "USER")
            "/data/data/com.termux.nix/files/home"
            files;
          "homeNixDroidDev" =
            homeDConf
            name
            (b.getEnv "HOME")
            files;
          "userHomeNixDroidDev" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            files;

          "nixDroidDevPkgs" =
            homeDConf
            name
            "/data/data/com.termux.nix/files/home"
            (files ++ pkgfiles);
          "userNixDroidDevPkgs" =
            homeDConf
            (b.getEnv "USER")
            "/data/data/com.termux.nix/files/home"
            (files ++ pkgfiles);
          "homeNixDroidDevPkgs" =
            homeDConf
            name
            (b.getEnv "HOME")
            (files ++ pkgfiles);
          "userHomeNixDroidDevPkgs" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            (files ++ pkgfiles);

          "testDroidDev" = homeConf "test" files;
          "testDroidDevPkgs" = homeConf "test" (files ++ pkgfiles);
        })
        # }}}
        # }}}
        # {{{ tablet
        // (let
          files = [
            # {{{
            ./common.nix
            ./commonLinks.nix
            ./specific/tablet.nix

            ./server/minimal.nix
            ./server/user.nix
            ./server/links.nix

            ./code/minimal.nix
            ./code/links.nix
            ./code/normal.nix
          ]; # }}}

          pkgfiles = [
            # {{{
            ./pkgs/common.nix
            ./pkgs/links.nix
            ./pkgs/codeMinimal.nix
            ./pkgs/codeNormal.nix
          ]; # }}}

          name = "michal";
        in {
          # {{{

          "testTabletDev" = homeConf "test" files;
          "testTabletDevPkgs" = homeConf "test" (files ++ pkgfiles);

          "tabletDev" = homeConf name files;
          "userTabletDev" = homeConf (b.getEnv "USER") files;
          "homeTabletDev" = homeConf name (b.getEnv "HOME") files;
          "userHomeTabletDev" = homeConf (b.getEnv "USER") (b.getEnv "HOME") files;

          "tabletDevPkgs" = homeConf name (files ++ pkgfiles);
          "userTabletDevPkgs" = homeConf (b.getEnv "USER") (files ++ pkgfiles);
          "homeTabletDevPkgs" = homeConf name (b.getEnv "HOME") (files ++ pkgfiles);
          "userHomeTabletDevPkgs" =
            homeDConf
            (b.getEnv "USER")
            (b.getEnv "HOME")
            (files ++ pkgfiles);
        })
        # }}}
        # }}}
        # {{{ TODO B michal
        // (let
          cfiles = [
            # {{{
            ./commmon.nix
            ./user/normal.nix

            ./code/pythonFull.nix
            ./code/minimal.nix
            ./code/normal.nix
            ./code/full.nix

            ./server/minimal.nix
            ./server/user.nix
          ]; # }}}

          afiles = [
            # {{{
            ./user/gits.nix
            ./user/full.nix
          ]; # }}}

          sfiles = [
            # {{{
            ./specific/common.nix
            ./commonLinks.nix
            ./code/links.nix
            ./server/links.nix
            ./code/links.nix
            ./user/links.nix
          ]; # }}}

          gfiles = [
            # {{{
            ./gitLinks.nix
          ]; # }}}

          pfiles = [
            # {{{
            ./pkgs/common.nix
            ./pkgs/userServer.nix

            ./pkgs/codeMinimal.nix
            ./pkgs/codeNormal.nix
            ./pkgs/codeFull.nix
          ]; # }}}
        in {
          # {{{
          #

          "michal" =
            homeConf "michal"
            (cfiles ++ afiles ++ gfiles);
          # TODO
          # }}}
        })
        # }}}
        ;

      inherit utils;
    });
}
