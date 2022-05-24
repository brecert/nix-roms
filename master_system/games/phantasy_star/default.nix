{ stdenvNoCC
, fetchFromGitHub
, wla-dx
}:

stdenvNoCC.mkDerivation {
  name = "phantasy-star";

  src = fetchFromGitHub {
    owner = "lory90";
    repo = "ps1disasm";
    rev = "b29ea788a5745cc11310d8e79d5d514e86126b6b";
    sha256 = "sha256-bq0IllqAzOVNjEveJKj3zuN+YJ+TT8nPyIFVlzcLd2c=";
  };

  nativeBuildInputs = [ wla-dx ];

  postPatch = ''
    substituteInPlace ps1.asm \
      --replace "banks\\" "banks/" \
      --replace "sound\\" "sound/"
  '';

  buildPhase = ''
    wla-z80 -v -o ps1.o ps1.asm
    wlalink -r link.txt out.sms
  '';

  installPhase = ''
    mv out.sms $out
  '';
}