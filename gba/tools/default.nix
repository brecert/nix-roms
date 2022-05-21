{ callPackage
, fetchFromGitHub
, mkToolsFor ? (callPackage ./builders.nix { }).mkToolsFor
}:

mkToolsFor (fetchFromGitHub {
  owner = "pret";
  repo = "pokeruby";
  rev = "1380ad46772737fd9a21a4ff4be9f61d81b59c4b";
  sha256 = "sha256-4SV0qMa4B1oUehCAvgCv/uvni9TFDIUuSgLE15Z4mkc=";
})
