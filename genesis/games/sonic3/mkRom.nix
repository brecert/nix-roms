{ stdenv
, callPackage
, fetchFromGitHub
, asl
, python
, s3p2bin ? callPackage ../../tools/s3p2bin { }
}:

{ assembleFlags ? [], ... }@attrs:

stdenv.mkDerivation ({
  src = fetchFromGitHub {
    owner = "sonicretro";
    repo = "skdisasm";
    rev = "dc3b0db93230eb31b8c074a878e9bae37c422724";
    sha256 = "sha256-sMUntm4jcGxHNkzC6o3f7jukg7v221teIE5COA7g/Yo=";
  };
  
  nativeBuildInputs = [ asl python s3p2bin ];

  assembleFlags = [ "-x" "-xx" "-n" "-c" "-A" "-L" ] ++ assembleFlags;

  buildPhase = ''
    runHook preBuild

    asl $assembleFlags
    s3p2bin sonic3k.p out.bin sonic3k.h -a

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv out.bin $out
    
    runHook postInstall
  '';
} // attrs)