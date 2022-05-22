{ stdenv
, callPackage
, bash
, gcc-arm-embedded-8
, libpng
}:

{ src
, romName
, mkToolsFor ? (callPackage ./mkPretTools.nix { }).mkToolsFor
, gbaTools ? mkToolsFor src
, ...
}@attrs:

stdenv.mkDerivation ({
  inherit src romName;

  nativeBuildInputs = [ gcc-arm-embedded-8 ];

  buildInputs = [ libpng ];

  doFixup = false;

  passthru = {
    inherit gbaTools;
  };

  patchPhase = ''
    runHook prePatch

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

    runHook postPatch
  '';

  postBuild = ''
    # we already have the tools so we disable tool building
    substituteInPlace Makefile \
        --replace "\$(MAKE) tools" ""
  '';

  buildPhase = ''
    runHook preBuild

    make $romName

    runHook postBuild
  '';

} // attrs)
