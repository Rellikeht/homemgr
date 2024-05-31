{lib, ...}: let
  b = builtins;
in rec {
  javaRawPaths = packages:
    b.listToAttrs (map (n: {
        name = n.name;
        value = {
          target = ".java/" + n.name;
          recursive = true;
          source = "${n.home}";
        };
      })
      packages);

  # Should be enough
  rmOne = sep: str: lib.head (lib.splitString sep str);
  rmNums = version: rmOne "." (rmOne "u" (rmOne "+" (rmOne "-" version)));
  clearName = name: rmOne "-" name;

  javaNamePaths = packages:
    b.listToAttrs (map (n: {
        name = n.name;
        value = {
          target = ".java/" + clearName n.name + rmNums n.version;
          recursive = true;
          source = "${n.home}";
        };
      })
      packages);

  javaDumbPaths = packages:
    b.listToAttrs (map (n: {
        name = n.name;
        value = {
          target = ".java/java" + rmNums n.version;
          recursive = true;
          source = "${n.home}";
        };
      })
      packages);

  repSym = c: c:
    if (c == "+" || c == "-" || c == ".")
    then "_"
    else c;

  javaRawVars = packages:
    b.listToAttrs (map (n: let
        listed = b.map repSym (lib.stringToCharacters n.name);
        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);

  javaNameVars = packages:
    b.listToAttrs (map (n: let
        listed = b.map repSym (lib.stringToCharacters (clearName n.name + rmNums n.version));
        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);

  javaDumbVars = packages:
    b.listToAttrs (map (n: let
        listed = b.map repSym (lib.stringToCharacters (rmNums n.version));
        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);
}
