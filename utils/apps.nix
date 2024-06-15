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

  # TODO something is wrong
  vimUp = name: ''
    ${name} -c ':norm ,qu' -c ':norm ,qP' -c ':qa!'
  '';

  vimUpPrep = ''
    export PATH="$PATH:/usr/bin/:/bin:/usr/local/bin:${pkgs.git}/bin:${pkgs.curl}/bin"
  '';
}
