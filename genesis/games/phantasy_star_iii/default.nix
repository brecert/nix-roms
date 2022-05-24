{ stdenvNoCC
, callPackage
, fetchzip
, fetchFromGitHub
, asl-1_42_211 ? callPackage ../../tools/asl-1_42_211 { }
, ps4p2bin ? callPackage ../../tools/ps4p2bin { }

  # 0 = Japanese; 1 = English; 2 = Portuguese
, revision ? 1
  # include bug fixes
, enableBugfixes ? false
  # enable running while holding the B button
, enableRunning ? false
  # Set this to true to remove the red cross sign from the nurse's coat, just like the Virtual Console version
, enableCrossPatch ? false
}:

let
  boolToInt = b: if b then "1" else "0"; # Convert boolean to integer string
in

stdenvNoCC.mkDerivation {
  name = "phantasy-star-iii";

  src = fetchFromGitHub {
    owner = "brecert";
    repo = "ps3disasm";
    rev = "b9b7d609ea6bafdee832bb0d574175fb3fe0a7f5";
    sha256 = "sha256-6ZmCmZvubLSA9rzsQATwzH6V+I65pnuFc42amFQhbhU=";
  };

  nativeBuildInputs = [
    # needed due to overflow errors otherwise, build version matches bundled `asw.exe`
    asl-1_42_211
    ps4p2bin
  ];

  dontPatch = true;
  dontFixup = true;

  configurePhase = ''
    runHook preConfig

    substituteInPlace ps3.options.asm \
      --replace "revision = 1" "revision = ${toString revision}" \
      --replace "bugfixes = 0" "bugfixes = ${boolToInt enableBugfixes}" \
      --replace "enable_run = 0" "enable_run = ${boolToInt enableRunning}" \
      --replace "cross_patch = 0" "cross_patch = ${boolToInt enableCrossPatch}"

    runHook postConfig
  '';

  buildPhase = ''
    runHook preBuild

    asl -c -A -i ./. -shareout out.h -o out.p ps3.asm
    ps4p2bin out.p out.bin out.h

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  
    mv out.bin $out
    
    runHook postInstall
  '';
}
