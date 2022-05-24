{ stdenvNoCC
, callPackage
, fetchFromGitHub
, asl
, writeText
, ps4p2bin ? callPackage ../../tools/ps4p2bin { }

  # 0 = Japanese; 1 = first US release; 2 = second US release; 3 = Portuguese
, revision ? 2

  # 0 address offsets in the form 0(a0) are optimized automatically by the assembler
  # the value 0 will turn this feature off. This is good for producing a byte-perfect copy of
  # the original ROM. When hacking, you don't need this so you can set it to 1 if you want
, enableZeroOffsetOptimization ? false
  # include bug fixes
, enableBugfixes ? false
  # Shir will no longer steal on Dezo
, enableDezoStealFix ? false
  # 0 = normal; 1 = double; 2 = quadruple
, walkSpeed ? 0
  # 0 = normal; 1 = double; 2 = quadruple
, expGain ? 0
  # 0 = normal; 1 = double; 2 = quadruple
, mesetaGain ? 0
  # remove the checksum calculation routine resulting in a faster boot time
, removeChecksum ? false
  # Set this to 1 to replace the green cross sign with an H and remove the red cross sign, just like the Virtual Console version
, enableCrossPatch ? false
}:

let
  boolToInt = b: if b then "1" else "0"; # Convert boolean to integer string

  configToOptions =
    { enableZeroOffsetOptimization
    , enableBugfixes
    , enableDezoStealFix
    , walkSpeed
    , expGain
    , mesetaGain
    , removeChecksum
    , enableCrossPatch
    }:
    writeText "ps2.options.asm" ''
      zeroOffsetOptimization = ${boolToInt enableZeroOffsetOptimization}

      bugfixes = ${boolToInt enableBugfixes}
      dezo_steal_fix = ${boolToInt enableDezoStealFix}
      walk_speed = ${toString walkSpeed}
      exp_gain = ${toString expGain}
      meseta_gain = ${toString mesetaGain}
      checksum_remove = ${boolToInt removeChecksum}
      revision = ${toString revision}
      cross_patch = ${boolToInt enableCrossPatch}
    '';

  config = {
    inherit enableZeroOffsetOptimization enableBugfixes enableDezoStealFix walkSpeed expGain mesetaGain removeChecksum enableCrossPatch;
  };
in

stdenvNoCC.mkDerivation {
  name = "phantasy-star-ii";

  src = fetchFromGitHub {
    owner = "brecert";
    repo = "ps2disasm";
    rev = "ec0051c28f9dada26ead2a8e8d759323de81ee0e";
    sha256 = "sha256-dqotyFUzeaUBxnftYcNwbaV0B1dGRi9ygoEBnu30zUs=";
  };

  nativeBuildInputs = [ asl ps4p2bin ];

  dontPatch = true;

  configurePhase = ''
    runHook preConfigure

    rm ps2.options.asm
    cp ${configToOptions config} ps2.options.asm

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    asl -c -A -i ./. -shareout out.h -o out.p ps2.asm
    ps4p2bin out.p out.bin out.h

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv out.bin $out

    runHook postInstall
  '';
}
