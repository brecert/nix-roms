{ stdenvNoCC
, callPackage
, fetchFromGitHub
, asl
, ps4p2bin ? callPackage ../../tools/ps4p2bin { }

  # 0 = Japanese; 1 = English; 2 = European
, revision ? 1
  # include bug fixes
, enableBugfixes ? false
  # include optional (larger) fixes
, enableFixes ? false
  # Set to true to tone down flashing effects; values are taken from the Virtual Console version
, enableLightSensitivityPatch ? false
  # dialogue is stored uncompressed
, uncompressedDialog ? false
}:

let
  boolToInt = b: if b then "1" else "0"; # Convert boolean to integer string
in

stdenvNoCC.mkDerivation {
  name = "phantasy-star-iv";

  src = fetchFromGitHub {
    owner = "lory90";
    repo = "ps4disasm";
    rev = "0a7f91745f29276de4db5da103f6c656af8d1e82";
    sha256 = "sha256-K00TEvDMQRCjpm3a/LlcftotvaL+Ffc1QJx0GeGvldM=";
  };

  nativeBuildInputs = [ asl ps4p2bin ];

  dontFixup = true;

  patchPhase = ''
    runHook prePatch
    
    mv "graphics/font/Font nemesis.bin" "graphics/font/Font Nemesis.bin"
  
    runHook postPatch
  '';

  configurePhase = ''
    runHook preConfig

    substituteInPlace ps4.options.asm \
      --replace "revision = 1" "revision = ${toString revision}" \
      --replace "bugfixes = 0" "bugfixes = ${boolToInt enableBugfixes}" \
      --replace "optional_fixes = 0" "optional_fixes = ${boolToInt enableFixes}" \
      --replace "light_sensitivity_patch = 0" "light_sensitivity_patch = ${boolToInt enableLightSensitivityPatch}" \
      --replace "dialogue_uncompressed = 0" "dialogue_uncompressed = ${boolToInt uncompressedDialog}"

    cat ps4.options.asm

    runHook postConfig
  '';

  buildPhase = ''
    runHook preBuild
    
    asl -c -A -i ./. -shareout out.h -o out.p ps4.asm
    ps4p2bin out.p out.bin out.h

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    
    mv out.bin $out

    runHook postInstall
  '';
}
