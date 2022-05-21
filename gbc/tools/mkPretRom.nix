{ stdenv
, rgbds
, which
, ...
}@attrs:

stdenv.mkDerivation ({
  nativeBuildInputs = [ rgbds which ];

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv $name.gbc $out
      
    runHook postInstall
  '';
} // attrs)
