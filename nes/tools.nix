{ pkgs, callPackage, ... }:

{
  asm6f = callPackage ./tools/asm6f pkgs;
  nesasm = callPackage ./tools/nesasm pkgs;
}
