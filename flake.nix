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
            inherit dotfiles unstable utils;
            inherit name stateVersion;
            pythonProv = pkgs.python311;
          };
        }
    );
  in {
    homeConfigurations = {
      # "${name}" = homeConf [./home.nix];

      # Because systemd can't be assured and
      # home manager may not be so useful with it
      # it has to be used carefully

      # TODO better python handling
      # TODO procedural creation
      # TODO Packages files, that may be super hard
      # TODO at the end activation should land here
      # TODO server
      # TODO root
      # TODO generating for user named from environmental
      # variable with --impure

      # Somehow finished
      "michalServer" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix
        ./serverMinimal.nix
        ./userServer.nix
      ];

      "michalCode" = homeConf "michal" [
        ./common.nix
        ./serverMinimal.nix
        ./codeMinimal.nix
        ./userServer.nix
      ];

      "michalFull" = homeConf "michal" [
        ./common.nix
        ./commonLinks.nix
        ./userServer.nix
        ./codeMinimal.nix
        ./codeFull.nix
        ./gits.nix
      ];

      "testUser" = homeConf "test" [
        ./common.nix
        ./commonLinks.nix
        ./serverMinimal.nix
        ./codeMinimal.nix
        ./codeFull.nix
        ./gits.nix
      ];

      "testServer" = homeConf "test" [
        ./common.nix
        ./commonLinks.nix
        ./serverMinimal.nix
        ./pythonMinimal.nix
        ./minecraftServer.nix
      ];

      "testDev" = homeConf "test" [
        ./common.nix
        ./gitLinks.nix
        ./serverMinimal.nix
        ./codeMinimal.nix
        ./codeFull.nix
        ./pythonFull.nix
        ./gits.nix
      ];
    };

    inherit utils;
  };
}
