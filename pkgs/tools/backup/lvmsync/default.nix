{ stdenv, bundlerEnv, ruby, bundlerUpdateScript, makeWrapper }:

let

  pname = "lvmsync";
  version = (import ./gemset.nix).${pname}.version;

  env = bundlerEnv {
    name = "${pname}-${version}-gems";
    ruby = ruby;
    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
  };

in stdenv.mkDerivation rec {
  inherit pname version;

  buildInputs = [ makeWrapper ];

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/lvmsync $out/bin/lvmsync
  '';

  passthru.updateScript = bundlerUpdateScript "lvmsync";

  meta = with stdenv.lib; {
    description = "Optimised synchronisation of LVM snapshots over a network";
    homepage = http://theshed.hezmatt.org/lvmsync/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine nicknovitski ];
  };

}
