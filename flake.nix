# vim: set et sw=2 ts=2:
{
  description = "Home Manager configuration of michal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      unstable = nixpkgs-unstable.legacyPackages.${system};
      builds = my-builds.packages.${system};

      stateVersion = "23.11";
      utils =
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

      homeDConf = (
        name: homeDir: mods:
          utils.confFunc {
            inherit pkgs lib;
            modules = mods;
            extraSpecialArgs = {
              inherit dotfiles utils;
              inherit unstable builds;
              inherit name homeDir stateVersion;
              # inherit dhallPrelude;

              # TODO procedural names of package sets
              pythonProv = pkgs.python311;
              pythonPkgs = pkgs.python311Packages;
              luaProv = pkgs.lua54;
              luaPkgs = pkgs.lua54Packages;
            };
          }
      );

      nix-droid-files = [
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

      nix-droid-pkgs = [
        ./pkgs/common.nix
        ./pkgs/codeMinimal.nix
      ];

      homeConf = name: mods: homeDConf name "" mods;
    in {
      packages.homeConfigurations = {
        # Because systemd can't be assured and
        # home manager may not be so useful with it
        # it has to be used carefully

        # TODO Packages files, that may be super hard
        # TODO at the end activation should land here
        # TODO generating for user named from environmental
        # variable with --impure
        # TODO procedural creation ???

        "simpleRoot" = homeDConf "root" "/root" [
          ./common.nix
          ./commonLinks.nix
          ./specific/root.nix
          ./code/minimal.nix
          ./code/links.nix
        ];

        "simpleServer" = homeConf "server" [
          ./common.nix
          ./commonLinks.nix
          ./specific/server.nix
          ./code/links.nix
          ./server/minecraft.nix
        ];

        "michalServer" = homeConf "michal" [
          ./common.nix
          ./commonLinks.nix
          ./specific/common.nix

          ./server/minimal.nix
          ./server/user.nix
          ./server/links.nix
          ./code/minimal.nix
          ./code/links.nix
        ];

        "nixDroidDev" = homeConf "nix-on-droid" nix-droid-files;
        "testDroidDev" = homeConf "test" nix-droid-files;
        "nixDroidDevPkgs" = homeConf "nix-on-droid" (
          nix-droid-files ++ nix-droid-pkgs
        );
        "testDroidDevPkgs" = homeConf "test" (
          nix-droid-files ++ nix-droid-pkgs
        );

        "testMinimal" = homeConf "test" [
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

        "testGlinks" = homeConf "test" [
          ./common.nix
          ./code/minimal.nix
          ./code/normal.nix
          ./specific/common.nix

          ./server/minimal.nix
          ./server/user.nix
          ./user/gits.nix
          ./user/gitLinks.nix
        ];

        "testUser" = homeConf "test" [
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

        "testServer" = homeConf "test" [
          ./common.nix
          ./commonLinks.nix
          ./specific/common.nix

          ./server/minimal.nix
          ./server/user.nix
          ./server/minecraft.nix

          ./code/pythonScraping.nix
        ];

        "testDev" = homeConf "test" [
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
      };

      inherit utils;
    });
}
