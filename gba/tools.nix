{ callPackage
, pretRom ? (callPackage ./games.nix { }).pokeruby
}:

# todo: determine if this is a good method
pretRom.gbaTools