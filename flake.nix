# vim: set et sw=2 ts=2:
{
  description = "Home Manager configuration of michal";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.11;
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
    home-manager,
    dotfiles,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    unstable = nixpkgs-unstable.legacyPackages.${system};
    name = "michal";

    stateVersion = "23.11";
  in {
    homeConfigurations = {
      "${name}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix

          {
            home = {
              inherit stateVersion;
            };
          }
        ];

        extraSpecialArgs = {
          inherit dotfiles unstable name;
        };
      };
    };
  };
}
