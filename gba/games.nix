{ pkgs
, lib
, stdenv
, gcc-arm-embedded-8
, libpng
, bash
  # gba tools
, aif2pcm
, bin2c
, gbafix
, gbagfx
, jsonproc
, mapjson
, mid2agb
, preproc
, ramscrgen
, rsfont
, scaninc
, agbcc
, ...
}:

let
  mkPokeRubySapphire = { pname, version, ... }@attrs:
    stdenv.mkDerivation (rec {
      inherit pname version;

      gameName = builtins.elemAt (builtins.split "_" version) 0;

      src = pkgs.fetchFromGitHub {
        owner = "pret";
        repo = "pokeruby";
        rev = "1380ad46772737fd9a21a4ff4be9f61d81b59c4b";
        sha256 = "sha256-4SV0qMa4B1oUehCAvgCv/uvni9TFDIUuSgLE15Z4mkc=";
      };

      nativeBuildInputs = [ gcc-arm-embedded-8 ];

      buildInputs = [ libpng ];

      doFixup = false;

      patchPhase = ''
        sed -e 's|/bin/bash|${bash}/bin/bash|g' -i Makefile -i *.sh

        rm -r tools
        mkdir tools
        ln -s ${aif2pcm} tools/aif2pcm
        ln -s ${bin2c} tools/bin2c
        ln -s ${gbafix} tools/gbafix
        ln -s ${gbagfx} tools/gbagfx
        ln -s ${jsonproc} tools/jsonproc
        ln -s ${mapjson} tools/mapjson
        ln -s ${mid2agb} tools/mid2agb
        ln -s ${preproc} tools/preproc
        ln -s ${ramscrgen} tools/ramscrgen
        ln -s ${rsfont} tools/rsfont
        ln -s ${scaninc} tools/scaninc

        ln -s ${agbcc} tools/agbcc

        # we already have the tools so we disable tool building
        substituteInPlace Makefile \
            --replace "\$(MAKE) tools" ""
      '';

      buildPhase = ''
        make $version
      '';

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

  inherit (lib) attrsets;
  inherit (attrsets) nameValuePair;
  inherit (builtins) listToAttrs;
in
listToAttrs (map
  (version: rec {
    name = "poke${version}";
    value = mkPokeRubySapphire { pname = name; inherit version; };
  })
  rubyVersions)
