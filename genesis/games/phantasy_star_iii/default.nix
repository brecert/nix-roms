{ stdenv
, callPackage
, fetchzip
, fetchFromGitHub
, asl-1_42_211 ? callPackage ../../tools/asl-1_42_211 { }
, ps4p2bin ? callPackage ../../tools/ps4p2bin { }
}:

stdenv.mkDerivation {
  name = "phantasy-star-iv";

  src = fetchFromGitHub {
    owner = "lory90";
    repo = "ps3disasm";
    rev = "c5a827a5da181c5508fbb4abe5afc8f53e413f6b";
    sha256 = "sha256-o8CWvOv6grMBDtAmbCBocODcNmudularcUY7FVSmmko=";
  };

  nativeBuildInputs = [
    # needed due to overflow errors otherwise, build version matches bundled `asw.exe`
    asl-1_42_211
    ps4p2bin
  ];

  patchPhase = ''
    substituteInPlace ps3.asm \
      --replace "general/portraits/mappings/uncompressed/Fortune teller.bin" "general/portraits/mappings/uncompressed/Fortune Teller.bin"
  '';

  buildPhase = ''
    asl -xx -c -E -A -l -E "!2" -i ./. -shareout out.h -o out.p ps3.asm > /dev/null
    ps4p2bin out.p out.bin out.h
  '';

  installPhase = ''
    mv out.bin $out
  '';
}
