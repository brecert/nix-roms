{ callPackage
, mkSonic3Rom ? callPackage ./games/sonic3/mkRom.nix { }
}:

{
  sonic3 = mkSonic3Rom {
    name = "Sonic 3";
    assembleFlags = [
      "-o sonic3k.p"
      "-olist sonic3k.lst"
      "-shareout sonic3k.h"
      "-i ./."
      "s3.asm"
    ];
  };

  sonicknuckles = mkSonic3Rom {
    name = "Sonic & Knuckles";
    assembleFlags = [
      "-D Sonic3_Complete=0"
      "-i ./."
      "sonic3k.asm"
    ];
  };

  sonic3knuckles = mkSonic3Rom {
    name = "Sonic & Knuckles + Sonic 3";
    assembleFlags = [
      "-D Sonic3_Complete=1"
      "-i ./."
      "sonic3k.asm"
    ];
  };

  phantasy_star_ii = callPackage ./games/phantasy_star_ii { };
  phantasy_star_iv = callPackage ./games/phantasy_star_iv { };
}
