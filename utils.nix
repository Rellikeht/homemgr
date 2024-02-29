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
  }: ''
    mkdir -p ${gitsDir}/${parent}
    cd ${gitsDir}/${parent}

    if [ "$(git ls-remote --get-url 2>/dev/null)" == "git@${provider}:${user}/${name}.git" ]
    [ "$(find 2>/dev/null | sed 2q | wc -l)" -gt 1 ] && \
      echo Cannot clone ${name} from ${provider} to nonempty directory >&2 && \
      exit 1

    git clone "https://${provider}/${user}/${name}
    git remote set-url origin git@${provider}:${user}/${name}.git

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
}
