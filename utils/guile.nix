{pkgs, ...}: let
  b = builtins;
in {
  guileLoadPath = libs: let
    siteDir = "${pkgs.guile.siteDir}";
  in (b.concatStringsSep ";"
    (map (l: "${l}/${siteDir}") libs));
}
