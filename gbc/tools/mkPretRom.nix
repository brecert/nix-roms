{ stdenv
, rgbds
, which
}:

{ name, ... }@attrs:

stdenv.mkDerivation ({
  inherit name;

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
