{ lib
, stdenv
, callPackage
, fetchFromGitHub
, version ? "us"
, asar ? (callPackage ../../tools/asar { })
}:

stdenv.mkDerivation {
  pname = "smw";
  version = version;

  src = fetchFromGitHub {
    owner = "meat-loaf";
    repo = "SMWDisX";
    rev = "241044e5d6da2ea738530067d3cef1d79006d04d";
    sha256 = "sha256-9D1goQMv4LwYmYQxylThwgoheySdbv8qPMzwvYgV08A=";
  };

  nativeBuildInputs = [ asar ];

  buildPhase = ''
    runHook preBuild

    make smw-$version.smc
    
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    
    mv smw-$version.smc $out
  
    runHook postInstall
  '';
}
