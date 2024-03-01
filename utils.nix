{
  pkgs,
  unstable,
  home-manager,
  dotfiles,
  stateVersion,
}: let
  lib = home-manager.lib;
  dags = lib.hm.dag;
  b = builtins;
  confFunc = home-manager.lib.homeManagerConfiguration;
in rec {
  inherit confFunc;

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

  guileLoadPath = libs: let
    siteDir = "${pkgs.guile.siteDir}";
  in (b.concatStringsSep ";"
    (map (l: "${l}/${siteDir}") libs));

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

    # TODO maybe more tests and proper replacing
    # if ! [
    #   "$(${git} config --get remote.origin.url 2>/dev/null)" ==
    #     "git@${provider}:${user}/${name}.git"
    #   ]
    # then
    #   [ "$(find 2>/dev/null | sed 2q | wc -l)" -gt 1 ] && \
    #     echo "Cannot clone ${name} from ${provider} to nonempty directory" >&2
    #     # echo "Cannot clone ${name} from ${provider} to nonempty directory" >&2 && \
    #     # exit 1

    if ! [ -e "${name}" ]
    then
      mkdir "${name}"
    fi

    if ! [ -d "${name}" ]
    then
      echo "${name} is not a directory" >&2
      exit 1
    fi

    if [ -z "$(ls -A ${name})" ]
    then
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
}
