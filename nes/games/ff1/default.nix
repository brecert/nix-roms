{ lib
, stdenvNoCC
, callPackage
, fetchFromGitHub
, cc65
}:

stdenvNoCC.mkDerivation {
  name = "ff1";

  src = fetchFromGitHub {
    owner = "Entroper";
    repo = "FF1Disassembly";
    rev = "c47ab71702bcd7f0b2a2221c55adc4c9fa941d80";
    sha256 = "sha256-nV+5Uq6qtkCBuQzHVmolr6+CVwb8W0BJXPJOZWy9FMA=";
  };

  nativeBuildInputs = [ cc65 ];

  buildPhase = ''
    cd "Final Fantasy Disassembly"

    runHook preBuild

    ca65 bank_01.asm --feature force_range
    ca65 bank_09.asm --feature force_range
    ca65 bank_0B.asm --feature force_range
    ca65 bank_0C.asm --feature force_range
    ca65 bank_0D.asm --feature force_range
    ca65 bank_0E.asm --feature force_range
    ca65 bank_0F.asm --feature force_range

    ld65 -C nes.cfg bank_01.o bank_09.o bank_0B.o bank_0C.o bank_0D.o bank_0E.o bank_0F.o

    cat nesheader.bin \
        bank_00.dat bank_01.bin \
        bank_02.dat bank_03.dat \
        bank_04.dat bank_05.dat \
        bank_06.dat bank_07.dat \
        bank_08.dat bank_09.bin \
        bank_0A.dat bank_0B.bin \
        bank_0C.bin bank_0D.bin \
        bank_0E.bin bank_0F.bin \
        > out.nes

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv out.nes $out

    runHook postInstall
  '';
}
