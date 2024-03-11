# vim: set et sw=2 ts=2:
{
  description = "Home Manager configuration of michal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # flakeUtils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:Rellikeht/dotfiles";
      flake = false;
    };

    builds.url = "github:Rellikeht/nix-builds";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    # flakeUtils,
    home-manager,
    dotfiles,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    unstable = nixpkgs-unstable.legacyPackages.${system};

    stateVersion = "23.11";
    utils =
      import ./utils.nix
      {
        inherit
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
          inherit pkgs;
          modules = mods;
          extraSpecialArgs = {
            inherit dotfiles unstable utils;
            inherit name homeDir stateVersion;
            pythonProv = pkgs.python311;
          };
        }
    );

    homeConf = name: mods: homeDConf name "" mods;
  in {
    homeConfigurations = {
      # "${name}" = homeConf [./home.nix];

      # Because systemd can't be assured and
      # home manager may not be so useful with it
      # it has to be used carefully

      # TODO better python handling
      # TODO Packages files, that may be super hard
      # TODO at the end activation should land here
      # TODO server
      # TODO root
      # TODO procedural creation ???
      # TODO generating for user named from environmental
      # variable with --impure

      "simpleRoot" = homeDConf "root" "/root" [
        ./common.nix
        ./commonLinks.nix
        ./code/minimal.nix
      ];

      "michalServer" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix

        ./server/minimal.nix
        ./server/user.nix
      ];

      "michalServerPkgs" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix

        ./server/minimal.nix
        ./server/user.nix

        ./pkgs/common.nix
        ./pkgs/userServer.nix

        ./code/pythonMinimal.nix
      ];

      "michalCode" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix

        ./server/minimal.nix
        ./server/user.nix

        ./code/minimal.nix
      ];

      "michalCodePkgs" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix
        ./server/minimal.nix
        ./server/user.nix

        ./pkgs/common.nix
        ./pkgs/userServer.nix
        ./pkgs/codeMinimal.nix

        ./code/minimal.nix
        ./code/pythonFull.nix
      ];

      # Somehow finished ↑

      "michalFull" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix

        ./code/minimal.nix
        ./code/full.nix

        ./server/user.nix
        ./user/gits.nix
      ];

      "michalFullPkgs" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix

        ./server/user.nix
        ./user/gits.nix

        ./code/minimal.nix
        ./code/full.nix
        ./code/pythonFull.nix

        ./pkgs/common.nix
        ./pkgs/userServer.nix
        ./pkgs/codeMinimal.nix
        ./pkgs/codeFull.nix
      ];

      "testUser" = homeConf "test" [
        ./common.nix
        ./commonLinks.nix

        ./code/minimal.nix
        ./code/full.nix

        ./server/minimal.nix
        ./user/gits.nix
      ];

      "testServer" = homeConf "test" [
        ./common.nix
        ./commonLinks.nix

        ./server/minimal.nix
        ./server/minecraft.nix

        ./code/pythonMinimal.nix
      ];

      "testDev" = homeConf "test" [
        ./common.nix

        ./user/gits.nix
        ./user/gitLinks.nix

        ./server/minimal.nix
        ./server/user.nix

        ./code/minimal.nix
        ./code/full.nix
        ./code/pythonFull.nix
      ];
    };

    inherit utils;
  };
}
