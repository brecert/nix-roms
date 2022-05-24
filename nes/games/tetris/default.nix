{ stdenv
, fetchFromGitHub
, python3
, cc65
}:

let
  python-env = python3.withPackages (p: [ p.pillow ]);
in

stdenv.mkDerivation {
  name = "nes-tetris";

  src = fetchFromGitHub {
    owner = "CelestialAmber";
    repo = "TetrisNESDisasm";
    rev = "8164694c6444ca7d4114ba159f730b774f93c6b8";
    sha256 = "sha256-zppIguEG/YL8b2MjbWrlno9xl7DjEN9PnsqDNbBDQEM=";
  };

  nativeBuildInputs = [ python-env cc65 ];

  dontFixup = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "tools/cc65" "${cc65}" \
      --replace "WINDOWS := \$(shell which wine ; echo \$\$?)" "WINDOWS := 1"
  '';

  installPhase = ''
    runHook preInstall

    mv tetris.nes $out

    runHook postInstall
  '';
}
