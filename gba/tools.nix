{ pkgs
, stdenv
, callPackage
, fetchFromGitHub
, libpng
, ...
}:

let
  mkTool = { name, ... }@attrs: stdenv.mkDerivation ({
    inherit name;

    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokeruby";
      rev = "1380ad46772737fd9a21a4ff4be9f61d81b59c4b";
      sha256 = "sha256-4SV0qMa4B1oUehCAvgCv/uvni9TFDIUuSgLE15Z4mkc=";
    };

    buildInputs = [ libpng ];

    preBuild = ''
      cd tools/$name
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out

      runHook postInstall
    '';
  } // attrs);
in
{
  agbcc = callPackage ./agbcc pkgs;

  gbagfx = mkTool {
    name = "gbagfx";
    buildInputs = [ libpng ];
  };

  aif2pcm = mkTool {
    name = "aif2pcm";
  };

  bin2c = mkTool {
    name = "bin2c";
  };

  gbafix = mkTool {
    name = "gbafix";
  };

  jsonproc = mkTool {
    name = "jsonproc";
  };

  mapjson = mkTool {
    name = "mapjson";
  };

  mid2agb = mkTool {
    name = "mid2agb";
  };

  preproc = mkTool {
    name = "preproc";
  };

  ramscrgen = mkTool {
    name = "ramscrgen";
  };

  rsfont = mkTool {
    name = "rsfont";
  };

  scaninc = mkTool {
    name = "scaninc";
  };
}
