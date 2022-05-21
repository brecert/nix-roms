{ pkgs, callPackage, ... }:

{
  smb1 = callPackage ./games/smb1 pkgs;
  smb3 = callPackage ./games/smb3 pkgs;
}
