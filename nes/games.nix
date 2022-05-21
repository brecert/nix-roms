{ pkgs, callPackage, ... }:

{
  smb1 = callPackage ./games/smb1 pkgs;
}