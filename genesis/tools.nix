{ stdenv
, fetchFromGitHub
, asl
, python
, ...
}:

let
  skdisarm-src = fetchFromGitHub {
    owner = "sonicretro";
    repo = "skdisasm";
    rev = "dc3b0db93230eb31b8c074a878e9bae37c422724";
    sha256 = "sha256-sMUntm4jcGxHNkzC6o3f7jukg7v221teIE5COA7g/Yo=";
  };
in

rec {
  s3p2bin = stdenv.mkDerivation {
    name = "s3p2bin";
    src = skdisarm-src;

    preBuild = ''
      cd AS/s3p2bin
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv s3p2bin $out/bin
    '';
  };

  mkSonic3Rom = { name, assembleFlags, ... }@attrs:
    stdenv.mkDerivation ({
      inherit name;

      src = skdisarm-src;

      nativeBuildInputs = [ asl python s3p2bin ];

      assembleFlags = [ "-x" "-xx" "-n" "-c" "-A" "-L" ] ++ assembleFlags;

      buildPhase = ''
        runHook preBuild

        asl $assembleFlags
        s3p2bin sonic3k.p "$name.bin" sonic3k.h -a

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mv "$name.bin" $out
        
        runHook postInstall
      '';
    } // attrs);
}
