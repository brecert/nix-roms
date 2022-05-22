{ callPackage }:

{
  smb1 = callPackage ./games/smb1 { };
  smb3 = callPackage ./games/smb3 { };
  ff1 = callPackage ./games/ff1 { };
}
