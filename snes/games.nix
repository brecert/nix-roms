{ callPackage
, mkSmw ? callPackage ./games/smw/rom.nix
}:

{
  smw-jp = mkSmw { version = "jp"; };
  smw-us = mkSmw { version = "us"; };
  smw-nss = mkSmw { version = "nss"; };
  smw-eu0 = mkSmw { version = "eu0"; };
  smw-eu1 = mkSmw { version = "eu1"; };
}
