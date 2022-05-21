{ pkgs, callPackage, ... }:

{
  asar = callPackage ./tools/asar pkgs;
}