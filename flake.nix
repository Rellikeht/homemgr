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

    utils = let
      lib = home-manager.lib;
      dags = lib.hm.dag;
      b = builtins;
    in rec {
      javaPaths = packages:
        b.listToAttrs (map (n: {
            name = n.name;
            value = {
              target = ".java/" + n.name;
              recursive = true;
              source = "${n}/";
            };
          })
          packages);
      # (map (x: b.trace x.outPath x) jdks));
      # TODO jdk vars, version is long, there should be something shorter

      configFiles = map (f: {
        name = f;
        value = {source = "${dotfiles}/" + f;};
      });

      configDirs = map (f: {
        name = f;
        value = {
          recursive = true;
          source = "${dotfiles}/" + f;
        };
      });

      configCDirs = map (f: {
        name = ".config/" + f;
        value = {
          recursive = true;
          source = "${dotfiles}/.config/" + f;
        };
      });

      dirMode = "750";
      createDir = n: ''
        mkdir -p $HOME/${n}
        chmod ${dirMode} $HOME/${n}
      '';
      createDirs = l: b.concatStringsSep "\n" (map createDir l);
    };

    confFunc = home-manager.lib.homeManagerConfiguration;
    homeConf = (
      name: modules:
        confFunc {
          inherit pkgs modules;
          extraSpecialArgs = {
            inherit dotfiles unstable name stateVersion utils;
          };
        }
    );

    name = "michal";
    stateVersion = "23.11";
  in {
    homeConfigurations = {
      # "${name}" = homeConf [./home.nix];
      "michalServer" = homeConf "michal" [
        ./common.nix
        ./michalServer.nix
      ];
    };

    inherit utils;
  };
}
