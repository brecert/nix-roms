{ pkgs
, stdenv
, callPackage
, libpng
, ...
}:

rec {
  mkToolFor = { name, src, ... }@attrs: stdenv.mkDerivation ({
    inherit name src;

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

  mkToolsFor = src:
    let
      # todo: I know nix probably has a better pattern for this
      mkTool = attrs: mkToolFor ({ inherit src; } // attrs);
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
        buildInputs = [ libpng ];
      };

      scaninc = mkTool {
        name = "scaninc";
      };
    };
}
