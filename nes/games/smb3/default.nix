{ lib
, pkgs
, stdenv
, callPackage
, fetchFromGitHub
, nesasm ? (callPackage ../../tools/nesasm pkgs)
, ...
}:

stdenv.mkDerivation {
  name = "smb3";

  src = fetchFromGitHub {
    owner = "captainsouthbird";
    repo = "smb3";
    rev = "b900ac59622f58a2266b30a32acc700e89415e83";
    sha256 = "sha256-CBte0W09BRn26Om/IA+i3xxcjtYYPKUjmQYADK6Iy1U=";
  };

  nativeBuildInputs = [ nesasm ];

  buildPhase = ''
    runHook preBuild

    nesasm smb3.asm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    
    ls
    mv smb3.nes $out

    runHook postInstall
  '';
}
