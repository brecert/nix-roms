{ lib
, pkgs
, stdenv
, callPackage
, fetchFromGitHub
, asm6f ? (callPackage ../../tools/asm6f pkgs)
, ...
}:

stdenv.mkDerivation {
  name = "smb1";

  src = fetchFromGitHub {
    owner = "Xkeeper0";
    repo = "smb1";
    rev = "1cc3c92cbbe8cda44903657f3da332688e806a89";
    sha256 = "sha256-U7+p2joNS64SCYbL/JVRTzIOSf0i5gnAahVP/cOtrb0=";
  };

  nativeBuildInputs = [ asm6f ];

  buildPhase = ''
    runHook preBuild

    asm6f smb1.asm -n -c -L bin/smb1.nes

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    
    mv bin/smb1.nes $out

    runHook postInstall
  '';
}