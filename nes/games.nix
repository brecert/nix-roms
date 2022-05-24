{ callPackage }:

{
  ff1 = callPackage ./games/ff1 { };
  smb1 = callPackage ./games/smb1 { };
  smb3 = callPackage ./games/smb3 { };
  nes-tetris = callPackage ./games/tetris { };
}
