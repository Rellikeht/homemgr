{
  lib,
  pkgs,
  unstable,
  home-manager,
  dotfiles,
  stateVersion,
}: let
  # lib = home-manager.lib;
  # dags = lib.hm.dag;
  b = builtins;

  confFunc = home-manager.lib.homeManagerConfiguration;
in rec {
  inherit confFunc;

  # TODO cron here, because it isn't available
  # somehow, no idea how hard this will be
  # TODO maybe some division

  guileLoadPath = libs: let
    siteDir = "${pkgs.guile.siteDir}";
  in (b.concatStringsSep ";"
    (map (l: "${l}/${siteDir}") libs));

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
        listed =
          # b.filter (c: (c != "+" && c != "-" && c != "."))
          b.map mf (lib.stringToCharacters n.name);

        cname = b.concatStringsSep "" listed;
      in {
        name = lib.toUpper ("java_" + cname + "_home");
        value = "${n.home}";
      })
      packages);

  configFiles = map (f: {
    name = f;
    value = {
      source = "${dotfiles}/" + f;
      force = true;
    };
  });

  configDirs = map (f: {
    name = f;
    value = {
      recursive = true;
      source = "${dotfiles}/" + f;
      force = true;
    };
  });

  # configCDirs = l: configDirs (map (n: ".config/" + n) l);

  configCDirs = map (f: {
    name = ".config/" + f;
    value = {
      recursive = true;
      source = "${dotfiles}/.config/" + f;
      force = true;
    };
  });

  dirMode = "750";
  createDir = n: ''
    mkdir -p $HOME/${n}
    chmod ${dirMode} $HOME/${n}
  '';
  createDirs = l: b.concatStringsSep "\n" (map createDir l);

  gitsDir = "$HOME/gits";
  me = "Rellikeht";
  github = "github.com";
  gitlab = "gitlab.com";

  # clone through https
  # change remote to ssh
  # all should be possible without agent and logging
  cloneGit = {
    user,
    name,
    provider,
    parent,
  }: let
    git = "${pkgs.git}/bin/git";
  in ''
    mkdir -p "${gitsDir}/${parent}"
    cd "${gitsDir}/${parent}"

    DONE=0
    if [ -e "${name}" ]; then
      if ! [ -d "${name}" ]; then
        echo "${name} is not a directory" >&2
        exit 1
      fi

      if [ "$(find 2>/dev/null | sed 2q | wc -l)" -gt 1 ]; then
        cd "${name}"

        if ! [ "$(${git} config --get remote.origin.url 2>/dev/null)" =\
          "git@${provider}:${user}/${name}.git" ]; then
          echo "There is another repo in the way of ${name} from ${provider}" >&2
          exit 1
        else
          DONE=1
        fi

        cd ..
      else
        echo "Cannot clone ${name} from ${provider} to nonempty directory" >&2
        exit 1
      fi

    else
      mkdir "${name}"
    fi

    if [ "$DONE" -eq 0 ]; then
      # TODO hide part of the progress
      ${git} clone "https://${provider}/${user}/${name}" "${name}"
      cd ${name}
      ${git} remote set-url origin "git@${provider}:${user}/${name}.git"
    fi

    cd $HOME
  '';

  cloneMyGithub = {
    name,
    parent,
  }:
    cloneGit {
      inherit name parent;
      user = me;
      provider = github;
    };

  cloneMyGitlab = {
    name,
    parent,
  }:
    cloneGit {
      inherit name parent;
      user = me;
      provider = gitlab;
    };

  cloneGithubs = parent: names:
    map (name: cloneMyGithub {inherit name parent;}) names;
  cloneGitlabs = parent: names:
    map (name: cloneMyGitlab {inherit name parent;}) names;

  mpv-unwrapped-full = final: prev: {
    mpv-unwrapped = prev.mpv-unwrapped.override {
      ffmpeg = pkgs.ffmpeg-full;
    };
  };

  vimUp = name: ''
    ${name} -c ':norm ,qu,qP:qa!'
  '';
  vimUpPrep = ''
    export PATH="$PATH:${pkgs.git}/bin:${pkgs.curl}/bin"
  '';
}
