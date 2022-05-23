{ stdenv
, callPackage
, fetchFromGitHub
, asl
, ps4p2bin ? callPackage ../../tools/ps4p2bin { }
}:

stdenv.mkDerivation {
  name = "phantasy-star-iv";

  src = fetchFromGitHub {
    owner = "lory90";
    repo = "ps4disasm";
    rev = "0a7f91745f29276de4db5da103f6c656af8d1e82";
    sha256 = "sha256-K00TEvDMQRCjpm3a/LlcftotvaL+Ffc1QJx0GeGvldM=";
  };

  nativeBuildInputs = [
    asl
    ps4p2bin
  ];

  postPatch = ''
    mv "graphics/font/Font nemesis.bin" "graphics/font/Font Nemesis.bin"
  '';

  buildPhase = ''
    asl -xx -c -E -A -l -E "!2" -i ./. -shareout out.h -o out.p ps4.asm > /dev/null
    ps4p2bin out.p out.bin out.h
  '';

  installPhase = ''
    mv out.bin $out
  '';
}
