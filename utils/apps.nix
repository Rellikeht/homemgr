{
  # {{{
  pkgs,
  ...
  # }}}
}: {
  mpv-unwrapped-full = final: prev: {
    mpv-unwrapped = prev.mpv-unwrapped.override {
      ffmpeg = pkgs.ffmpeg-full;
    };
  };

  vimUp = name:
  #  {{{
  ''
    ${name} -e -i NONE \
      -c 'PlugClean!' -c PlugUpgrade -c PlugUpdate -c visual -c 'PlugClean!' -c 'qa!'
  ''; #  }}}

  vimUpPrep = ''
    export PATH="$PATH:/usr/bin/:/bin:/usr/local/bin:${pkgs.git}/bin:${pkgs.curl}/bin"
  '';
}
