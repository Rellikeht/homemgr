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

      homeConfs = {
        # {{{
        confName,
        name,
        home ? "",
        mods,
        # }}}
      }:
        b.listToAttrs [
          # {{{
          {
            name = confName;
            value = homeDConf name home mods;
          }
          {
            name = "user" + utils.firstUpper confName;
            value = homeDConf (b.getEnv "USER") home mods;
          }
          {
            name = "home" + utils.firstUpper confName;
            value = homeDConf name (b.getEnv "HOME") mods;
          }
          {
            name = "userHome" + utils.firstUpper confName;
            value = homeDConf (b.getEnv "USER") (b.getEnv "HOME") mods;
          }
        ]; # }}}

      testConf = mods: homeDConf "test" "" mods;
      # }}}

      # {{{
      tabName = "phablet";
      userName = "michal";
      serverName = "server";
      wslName = "lamus";
      droidName = "nix-on-droid";
      # }}}
    in {
      packages.homeConfigurations =
        {
          # {{{ tests
          # }}}
        }
        // ( # {{{ shallow
          let
            # {{{
            mods = [
              ./commonLinks.nix
              ./specific/shallow.nix
              ./code/links.nix
              ./server/links.nix
            ];
            umods = mods ++ [./user/links.nix];
            # }}}
          in
            # {{{
            (homeConfs {
              name = userName;
              inherit mods;
              confName = "shallow";
            })
            // (homeConfs {
              name = userName;
              mods = umods;
              confName = "shallowUser";
            })
            // (homeConfs {
              name = tabName;
              mods = umods;
              confName = "shallowTab";
            })
          # }}}
        ) # }}}
        // ( # {{{ simple root
          let
            # {{{
            mods = [
              # {{{
              ./common.nix
              ./commonLinks.nix
              ./specific/root.nix
              ./code/minimal.nix
              ./code/links.nix
            ]; # }}}

            pkgMods = [
              # {{{
              ./pkgs/common.nix
              ./pkgs/links.nix
              ./pkgs/codeMinimal.nix
            ]; # }}}
            # }}}
          in
            # {{{
            (homeConfs {
              name = "root";
              home = "/root";
              inherit mods;
              confName = "simpleRoot";
            })
            // (homeConfs {
              name = "root";
              home = "/root";
              mods = mods ++ pkgMods;
              confName = "simpleRootPkgs";
            })
          # }}}
        ) # }}}
        // ( # {{{ simple server
          let
            mods = [
              # {{{
              ./common.nix
              ./commonLinks.nix
              ./specific/server.nix
              ./code/links.nix
            ]; # }}}
            mmods = mods ++ [./server/minecraft.nix];
          in
            # {{{
            (homeConfs {
              name = serverName;
              inherit mods;
              confName = "simpleServer";
            })
            // (homeConfs {
              name = serverName;
              mods = mmods;
              confName = "minecraftServer";
            })
            // {
              "michalSimpleServer" = homeConf userName mods;
            }
          # }}}
        )
        # }}}
        // ( # {{{ server
          let
            mods = [
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
          in
            # {{{
            (homeConfs {
              name = userName;
              inherit mods;
              confName = "userServer";
            })
            // (homeConfs {
              name = userName;
              mods = mods ++ [./code/scraping.nix];
              confName = "userSServer";
            })
            // {
            }
          # }}}
        ) # }}}
        // ( # {{{ TODO B wsl
          let
            mods = [
              # {{{
              ./common.nix
              ./commonLinks.nix
              ./specific/wsl.nix
              ./code/links.nix
            ]; # }}}
          in
            # {{{
            (homeConfs {
              name = wslName;
              inherit mods;
              confName = "simpleWsl";
            })
            # TODO C full
            // {
              "michalSimpleWsl" = homeConf userName mods;
            }
          # }}}
        )
        # }}}
        // ( # {{{ droid
          let
            # ocaml-lsp dependencies builds are failing
            # because build instructions are fucked
            # it needs access to root filesystem or something
            mods = [
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

            pkgMods = [
              # {{{
              ./pkgs/common.nix
              ./pkgs/links.nix
              ./pkgs/codeMinimal.nix
              ./pkgs/codeNormal.nix
            ]; # }}}
          in
            # {{{
            (homeConfs {
              name = droidName;
              inherit mods;
              confName = "droidDev";
            })
            // (homeConfs {
              name = droidName;
              mods = mods ++ pkgMods;
              confName = "droidDevPkgs";
            })
            // {
              # {{{
              "testDroidDev" = testConf mods;
              "testDroidDevPkgs" = testConf (mods ++ pkgMods);
            } # }}}
          # }}}
        ) # }}}
        // ( # {{{ tablet
          let
            mods = [
              # {{{
              ./common.nix
              ./commonLinks.nix
              ./user/normal.nix
              ./specific/tablet.nix

              ./server/minimal.nix
              ./server/user.nix
              ./server/links.nix

              ./code/minimal.nix
              ./code/links.nix
              ./code/normal.nix
            ]; # }}}

            pkgMods = [
              # {{{
              ./pkgs/common.nix
              ./pkgs/links.nix
              ./pkgs/userServer.nix
              ./pkgs/codeMinimal.nix
              ./pkgs/codeNormal.nix
            ]; # }}}

            guiMods = [
              # {{{
              ./user/guiMinimal.nix
            ]; # }}}

            guiPkgs = [
              # {{{
              ./pkgs/guiMinimal.nix
            ]; # }}}
          in
            # {{{
            (homeConfs {
              name = tabName;
              inherit mods;
              confName = "tabletDev";
            })
            // (homeConfs {
              name = tabName;
              mods = mods ++ pkgMods;
              confName = "tabletDevPkgs";
            })
            // (homeConfs {
              name = tabName;
              mods = mods ++ guiPkgs;
              confName = "tabletDevGui";
            })
            // (homeConfs {
              name = tabName;
              mods = mods ++ pkgMods ++ guiMods ++ guiPkgs;
              confName = "tabletDevGuiPkgs";
            })
            // {
              # {{{
              "testTabletDev" = testConf mods;
              "testTabletDevPkgs" = testConf (mods ++ pkgMods);
              "testTabletDevGui" = testConf (mods ++ guiMods);
              "testTabletDevGuiPkgs" = homeConf "test" (mods ++ pkgMods ++ guiMods ++ guiPkgs);
              # }}}
            }
          # }}}
        ) # }}}
        // ( # {{{ TODO B michal
          let
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
              ./user/gitLinks.nix
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
          }
        )
        # }}}
        ;

      inherit utils;
    });
}
