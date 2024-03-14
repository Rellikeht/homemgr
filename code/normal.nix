# vim: set et sw=2 ts=2:
{
  # config,
  pkgs,
  unstable,
  # lib,
  # dotfiles,
  # name,
  # stateVersion,
  utils,
  ...
}: let
  b = builtins;

  normalPackages = with pkgs; [
    luajit
  ];

  unstablePackages = with unstable; ([
      ocamlformat
      gopls
    ]
    ++ (with ocamlPackages; [
      utop
    ])
    ++ (with haskellPackages; [
      ]));
  # dots = "${dotfiles}";
in {
  home = {
    sessionVariables = {
    };

    file =
      {
      }
      // b.listToAttrs (utils.configDirs [
        ])
      // b.listToAttrs (utils.configCDirs [
        ]);

    packages = normalPackages ++ unstablePackages;
  };
}
