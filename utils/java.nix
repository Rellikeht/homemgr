{lib, ...}: let
  b = builtins;
in {
  javaPaths = packages:
    b.listToAttrs (map (n: {
        name = n.name;
        value = {
          target = ".java/" + n.name;
          recursive = true;
          source = "${n.home}";
        };
      })
      packages);

  javaVars = packages:
    b.listToAttrs (map (n: let
        mf = c:
          if (c == "+" || c == "-" || c == ".")
          then "_"
          else c;
        listed = b.map mf (lib.stringToCharacters n.name);
        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);
}
