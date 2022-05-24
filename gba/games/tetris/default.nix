{ stdenvNoCC
, callPackage
, fetchFromGitHub
, rgbds
}:

stdenvNoCC.mkDerivation {
  name = "gameboy-tetris";

  src = fetchFromGitHub {
    owner = "alexsteb";
    repo = "tetris_disassembly";
    rev = "b4bbceb3cc086121ab4fe9bf4dad6752fe956ec0";
    sha256 = "sha256-uYe3/HJlUNvjVQ6peamZbYaDHywUmTR0gsoJgxh5/Ko=";
  };

  nativeBuildInputs = [ rgbds ];

  dontFixup = true;
  dontPatch = true;

  buildPhase = ''
    runHook preBuild

    rgbasm -o main.o main.asm
    rgblink -o tetris.gb main.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv tetris.gb $out

    runHook postInstall
  '';
}
