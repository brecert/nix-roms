{ callPackage
, genesis ? (callPackage ./tools.nix { })
}:

{
  sonic3 = genesis.mkSonic3Rom {
    name = "Sonic 3";
    assembleFlags = [
      "-o sonic3k.p"
      "-olist sonic3k.lst"
      "-shareout sonic3k.h"
      "-i ./."
      "s3.asm"
    ];
  };

  sonicknuckles = genesis.mkSonic3Rom {
    name = "Sonic & Knuckles";
    assembleFlags = [
      "-D Sonic3_Complete=0"
      "-i ./."
      "sonic3k.asm"
    ];
  };

  sonic3knuckles = genesis.mkSonic3Rom {
    name = "Sonic & Knuckles + Sonic 3";
    assembleFlags = [
      "-D Sonic3_Complete=1"
      "-i ./."
      "sonic3k.asm"
    ];
  };
}
