{ lib
, stdenv
, fetchFromGitHub
, ...
}:

stdenv.mkDerivation {
  pname = "asm6f";
  version = "master";

  src = fetchFromGitHub {
    owner = "freem";
    repo = "asm6f";
    rev = "06ab0f14234cd2ef3a2fe819e959f69d750ad1b8";
    sha256 = "sha256-iPCvN/pJ8Fd3a7zKnzSS35u/J+RzioCGuv7fJSTmzw0=";
  };

  buildPhase = ''
    runHook preBuild

    gcc -Wall asm6f.c -o asm6f

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp asm6f $out/bin/asm6f

    runHook postInstall
  '';
}
