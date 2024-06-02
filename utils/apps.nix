{pkgs, ...}: {
  mpv-unwrapped-full = final: prev: {
    mpv-unwrapped = prev.mpv-unwrapped.override {
      ffmpeg = pkgs.ffmpeg-full;
    };
  };

  # WTF
  vimUp = name: ''
    ${name} -c ':norm ,qu' -c ':norm <Esc>' -c ':norm ,qP' -c ':qa!'
  '';

  vimUpPrep = ''
    export PATH="$PATH:/usr/bin/:/bin:/usr/local/bin:${pkgs.git}/bin:${pkgs.curl}/bin"
  '';
}
