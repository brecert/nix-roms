{ lib
, stdenv
, fetchFromGitHub
, ...
}:

stdenv.mkDerivation {
  pname = "nesasm";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "camsaul";
    repo = "nesasm";
    rev = "229033a4b76466b447ad47704808a4d03c493cee";
    sha256 = "sha256-56P/FFd9sehxBihQ5IdE6qipfeQOf2/37eAaT2RjFdo=";
  };

  preBuild = ''
    cd source
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    mv ../nesasm $out/bin/nesasm 

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/camsaul/nesasm";
    description = "NES 6502 assembler";
    platforms = platforms.all; # probably?
  };
}