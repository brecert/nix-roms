{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "s3p2bin";
  src = fetchFromGitHub {
    owner = "sonicretro";
    repo = "skdisasm";
    rev = "dc3b0db93230eb31b8c074a878e9bae37c422724";
    sha256 = "sha256-sMUntm4jcGxHNkzC6o3f7jukg7v221teIE5COA7g/Yo=";
  };

  preBuild = ''
    cd AS/s3p2bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv s3p2bin $out/bin
  '';
}