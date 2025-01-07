{pkgs, ...}: rec {
  #  {{{
  gitsDir = "$HOME/gits";
  me = "Rellikeht";
  github = "github.com";
  gitlab = "gitlab.com";
  # }}}

  # clone through https
  # change remote to ssh
  # all should be possible without agent and logging
  cloneGit = {
    #  {{{
    user,
    name,
    provider,
    parent,
    #  }}}
  }: let
    git = "${pkgs.git}/bin/git";
  in
    #  {{{
    ''
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
    ''; #  }}}

  cloneMyGithub = {
    #  {{{
    name,
    parent,
  }:
    cloneGit {
      inherit name parent;
      user = me;
      provider = github;
    };
  #  }}}

  cloneMyGitlab = {
    #  {{{
    name,
    parent,
  }:
    cloneGit {
      inherit name parent;
      user = me;
      provider = gitlab;
    };
  #  }}}

  cloneGithubs = parent: names:
    map (name: cloneMyGithub {inherit name parent;}) names;
  cloneGitlabs = parent: names:
    map (name: cloneMyGitlab {inherit name parent;}) names;
}
