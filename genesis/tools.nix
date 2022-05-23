{ callPackage }:

{
  s3p2bin = callPackage ./tools/s3p2bin { };
  ps4p2bin = callPackage ./tools/ps4p2bin { };
}
