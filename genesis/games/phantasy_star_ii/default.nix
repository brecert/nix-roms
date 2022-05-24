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
    repo = "ps2disasm";
    rev = "eda0746b32b0b78ac7d39df94d22db594fc358d9";
    sha256 = "sha256-9fI/L0/8QrQVkRq1E9oYk5XborMpVclV79uWhRoow6E=";
  };

  nativeBuildInputs = [
    asl
    ps4p2bin
  ];

  postPatch = ''
    substituteInPlace ps2.asm \
      --replace "palettes/sega" "palettes/Sega" \
      --replace "palettes/NPC/dezolian 2 portrait.bin" "palettes/NPC/Dezolian 2 portrait.bin" \
      --replace "palettes/NPC/dezolian 3 portrait.bin" "palettes/NPC/Dezolian 3 portrait.bin" \
      --replace "palettes/NPC/dezolian 4 portrait.bin" "palettes/NPC/Dezolian 4 portrait.bin" \
      --replace "palettes/misc/Space Travel.bin" "palettes/misc/Space travel.bin"
  '';

  buildPhase = ''
    asl -xx -c -E -A -l -E "!2" -i ./. -shareout out.h -o out.p ps2.asm > /dev/null
    ps4p2bin out.p out.bin out.h
  '';

  installPhase = ''
    mv out.bin $out
  '';
}
