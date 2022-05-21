{ lib
, stdenv
, fetchFromGitHub
, python3
, rgbds
  # azle-r2.gbc (English, v1.2)
, romName ? "azle-r2"
, version ? "1.2"
}:

stdenv.mkDerivation {
  inherit version romName;
  pname = "ladx";

  src = fetchFromGitHub {
    owner = "zladx";
    repo = "LADX-Disassembly";
    rev = "2b7d5289b419caaa986f30443e90c7cc0f0f598e";
    sha256 = "sha256-i5dQiyvffTBtokhhfayEzABgXYvwFkHvSIWrZl8itHs=";
  };

  nativeBuildInputs = [ rgbds python3 ];

  buildPhase = ''
    patchShebangs ./tools ./tools/gfx
    make $romName.gbc
  '';

  installPhase = ''
    runHook preInstall

    mv $romName.gbc $out
    
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/zladx/LADX-Disassembly";
    description = "Links Awakening DX ${language} translation";
  };
}
