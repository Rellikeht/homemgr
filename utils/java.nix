{lib, ...}: let
  # {{{
  b = builtins;
  # }}}
in rec {
  # {{{ helpers

  # Should be enough
  rmOne = sep: str: lib.head (lib.splitString sep str);
  rmNums = version: rmOne "." (rmOne "u" (rmOne "+" (rmOne "-" version)));
  clearName = name: rmOne "-" name;

  repSym = c:
    if (c == "+" || c == "-" || c == ".")
    then "_"
    else c;

  # }}}

  # {{{ paths

  javaRawPaths = packages:
    b.listToAttrs (map (n: let
        path = ".java/" + n.name;
      in {
        name = path;
        value = {
          target = path;
          recursive = true;
          source = "${n.home}";
        };
      })
      packages);

  javaNamePaths = packages:
    b.listToAttrs (map (n: let
        path = ".java/" + clearName n.name + rmNums n.version;
      in {
        name = path;
        value = {
          target = path;
          recursive = true;
          source = "${n.home}";
        };
      })
      packages);

  javaDumbPaths = packages:
    b.listToAttrs (map (n: let
        path = ".java/java" + rmNums n.version;
      in {
        name = path;
        value = {
          target = path;
          recursive = true;
          source = "${n.home}";
        };
      })
      packages);

  # }}}

  # {{{ vars

  javaRawVars = packages:
    b.listToAttrs (map (n: let
        listed = map repSym (lib.stringToCharacters n.name);
        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);

  javaNameVars = packages:
    b.listToAttrs (map (n: let
        listed = map repSym (lib.stringToCharacters (clearName n.name + rmNums n.version));
        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);

  javaDumbVars = packages:
    b.listToAttrs (map (n: let
        listed = map repSym (lib.stringToCharacters (rmNums n.version));
        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);

  # }}}
}
