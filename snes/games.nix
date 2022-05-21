{ pkgs, callPackage, ... }:

{
  smw-jp = callPackage ./games/smw/rom.nix { version = "jp"; };
  smw-us = callPackage ./games/smw/rom.nix { version = "us"; };
  smw-nss = callPackage ./games/smw/rom.nix { version = "nss"; };
  smw-eu0 = callPackage ./games/smw/rom.nix { version = "eu0"; };
  smw-eu1 = callPackage ./games/smw/rom.nix { version = "eu1"; };
}