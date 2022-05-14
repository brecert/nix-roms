{ pkgs
, lib
, stdenv
, gcc-arm-embedded-8
, libpng
, bash
, mkToolsFor ? (import ./tools/builders.nix pkgs).mkToolsFor
, ...
}:

let
  buildGBARom = { src, gbaTools ? mkToolsFor src, ... }@attrs: stdenv.mkDerivation ({
    inherit src;

    nativeBuildInputs = [ gcc-arm-embedded-8 ];

    buildInputs = [ libpng ];

    doFixup = false;

    patchPhase = ''
      sed -e 's|/bin/bash|${bash}/bin/bash|g' -i Makefile -i *.sh

      rm -r tools
      mkdir tools
      ln -s ${gbaTools.aif2pcm} tools/aif2pcm
      ln -s ${gbaTools.bin2c} tools/bin2c
      ln -s ${gbaTools.gbafix} tools/gbafix
      ln -s ${gbaTools.gbagfx} tools/gbagfx
      ln -s ${gbaTools.jsonproc} tools/jsonproc
      ln -s ${gbaTools.mapjson} tools/mapjson
      ln -s ${gbaTools.mid2agb} tools/mid2agb
      ln -s ${gbaTools.preproc} tools/preproc
      ln -s ${gbaTools.ramscrgen} tools/ramscrgen
      ln -s ${gbaTools.rsfont} tools/rsfont
      ln -s ${gbaTools.scaninc} tools/scaninc

      ln -s ${gbaTools.agbcc} tools/agbcc

      # we already have the tools so we disable tool building
      substituteInPlace Makefile \
          --replace "\$(MAKE) tools" ""
    '';

    buildPhase = ''
      make $version
    '';

  } // attrs);

  mkPokeRubySapphire = { pname, version, ... }@attrs:
    buildGBARom (rec {
      inherit pname version;

      src = pkgs.fetchFromGitHub {
        owner = "pret";
        repo = "pokeruby";
        rev = "1380ad46772737fd9a21a4ff4be9f61d81b59c4b";
        sha256 = "sha256-4SV0qMa4B1oUehCAvgCv/uvni9TFDIUuSgLE15Z4mkc=";
      };

      installPhase = ''
        mv poke$version.gba $out
      '';
    } // attrs);

  mkPokeFireRedLeafGreen = { pname, version, ... }@attrs:
    buildGBARom ({
      inherit pname version;

      src = pkgs.fetchFromGitHub {
        owner = "pret";
        repo = "pokefirered";
        rev = "0ef73070401817add41f79cb8ad2a89077e272b7";
        sha256 = "sha256-lN0W/mF/I4PAsqNz68d+x+/rkVAQJkhnJ8892B12uGU=";
      };

      installPhase = ''
        mv poke$version.gba $out
      '';
    } // attrs);

  rubyVersions = [
    "ruby"
    "ruby_rev1"
    "ruby_rev2"
    "sapphire"
    "sapphire_rev1"
    "sapphire_rev2"
    # "ruby_de"
    # "ruby_de_rev1"
    # "sapphire_de"
    # "sapphire_de_rev1"
  ];

  fireRedVersions = [
    "firered"
    "firered_rev1"
    "leafgreen"
    "leafgreen_rev1"
  ];

  inherit (lib) attrsets;
  inherit (attrsets) nameValuePair;
  inherit (builtins) listToAttrs;
in
(listToAttrs (map
  (version: rec {
    name = "poke${version}";
    value = mkPokeRubySapphire { pname = name; inherit version; };
  })
  rubyVersions)) //
(listToAttrs (map
  (version: rec {
    name = "poke${version}";
    value = mkPokeFireRedLeafGreen { pname = name; inherit version; };
  })
  fireRedVersions))
