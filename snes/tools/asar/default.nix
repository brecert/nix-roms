{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ...
}:

stdenv.mkDerivation {
  pname = "asar";
  version = "1.81";

  src = fetchFromGitHub {
    owner = "RPGHacker";
    repo = "asar";
    rev = "v1.81";
    sha256 = "sha256-nbVb6Y7Plr2EgDWzNMA8I2m3QPNAVfyCMWEd519fUco=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  preConfigure = ''
    cd src/asar
  ''; 

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv asar-standalone $out/bin/$pname
  
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/RPGHacker/asar";
    description = "SNES assembler, originally created by Alcaro";
    platforms = platforms.all; # probably?
  };
}