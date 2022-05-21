{ callPackage }:

{
  asm6f = callPackage ./tools/asm6f { };
  nesasm = callPackage ./tools/nesasm { };
}
