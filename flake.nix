# vim: set et sw=2 ts=2:
{
  description = "Home Manager configuration of michal";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.11;
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flakeUtils.url = github:numtide/flake-utils;

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = github:Rellikeht/dotfiles;
      flake = false;
    };

    builds.url = github:Rellikeht/nix-builds;
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    flakeUtils,
    home-manager,
    dotfiles,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    unstable = nixpkgs-unstable.legacyPackages.${system};

    name = "michal";
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

    homeConf = (
      name: mods:
        utils.confFunc {
          inherit pkgs;
          modules = mods;
          extraSpecialArgs = {
            inherit dotfiles unstable name stateVersion utils;
          };
        }
    );
  in {
    # TODO versions for development: dotfiles repo cloned
    # somewhere and files from there symlinked
    # to home

    homeConfigurations = {
      # "${name}" = homeConf [./home.nix];

      # Somehow finished
      "michalServer" = homeConf "michal" [
        ./common.nix
        ./serverMinimal.nix
        ./michalServer.nix
      ];

      "michalCode" = homeConf "michal" [
        ./common.nix
        ./serverMinimal.nix
        ./codeMinimal.nix
        ./michalServer.nix
      ];

      "michalFull" = homeConf "michal" [
        ./common.nix
        ./michalServer.nix
        ./codeMinimal.nix
        ./codeFull.nix
      ];

      "codePkgsFull" = homeConf "michal" [
        ./codePkgsFull.nix
      ];
    };

    inherit utils;
  };
}
