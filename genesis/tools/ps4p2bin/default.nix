{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "ps4p2bin";

  src = fetchFromGitHub {
    owner = "lory90";
    repo = "ps4disasm";
    rev = "0a7f91745f29276de4db5da103f6c656af8d1e82";
    sha256 = "sha256-K00TEvDMQRCjpm3a/LlcftotvaL+Ffc1QJx0GeGvldM=";
  };

  buildPhase = ''
    cd AS

    runHook preBuild

    cc ps4p2bin.c -o ps4p2bin

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ps4p2bin $out/bin
  '';
}
