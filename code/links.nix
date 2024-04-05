# vim: set et sw=2 ts=2:
{
  # dotfiles,
  utils,
  ...
}: let
  # dags = lib.hm.dag;
  b = builtins;
  # dots = "${dotfiles}";
  # homeDirectory = "/home/${name}";
in {
  home = {
    file =
      {}
      // b.listToAttrs (utils.configFiles [
        ])
      // b.listToAttrs (utils.configDirs [
        "Templates"
      ])
      // b.listToAttrs (utils.configCDirs [
        "bpython"
        "nim"
        "kak"
      ]);
  };
}
