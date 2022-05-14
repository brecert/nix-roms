{ stdenv
, fetchFromGitHub
, rgbds
, which
, ...
}:

let
  buildGBCRom = { name, src, ... }@attrs:
    stdenv.mkDerivation ({
      inherit name src;
      buildInputs = [
        rgbds
        which
      ];

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
    } // attrs);

  pokered-src = fetchFromGitHub {
    owner = "pret";
    repo = "pokered";
    rev = "64e2b66a610d330bfdad108a603027be9652a7e7";
    sha256 = "sha256-SfStLJbh8FvwBPfF/2TZVTW9cKY8tQNAk0Li8ajeTPI=";
  };

  pokegold-src = fetchFromGitHub {
    owner = "pret";
    repo = "pokegold";
    rev = "3ce41509db5a3c95ea6cec173e79557b771857a7";
    sha256 = "sha256-xr1jaOA+dXKg2mG2aSn9B5Lxp9uJCYdPUho2TlRFJX0=";
  };
in
{
  pokered = buildGBCRom {
    name = "pokered";
    src = pokered-src;
  };

  pokeblue = buildGBCRom {
    name = "pokeblue";
    src = pokered-src;
  };

  pokeyellow = buildGBCRom {
    name = "pokeyellow";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokeyellow";
      rev = "c73b4ec86e167a8aabee0e0cb6ed6ab485fbcce2";
      sha256 = "sha256-bUv/PDFX/kYZBrfd3PjYGzHqY4sp0YOz10rovVmwZFM=";
    };
  };

  pokegold = buildGBCRom {
    name = "pokegold";
    src = pokegold-src;
  };

  pokesilver = buildGBCRom {
    name = "pokesilver";
    src = pokegold-src;
  };

  pokecrystal = buildGBCRom {
    name = "pokecrystal";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokecrystal";
      rev = "fbcc8d1b0e05cace2abe2083a88a8c2304efc9d7";
      sha256 = "sha256-UY6oLESmDHJgat4Qnsk/67cqgYz08dgSTTmRHgFYfKE=";
    };
  };

  pokepinball = buildGBCRom {
    name = "pokepinball";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokepinball";
      rev = "14c3e9b94f8d920101f39e724abcb122b44f4aea";
      sha256 = "sha256-DNd7+tBi6JKffxuuABSzp41E1GF45dyxyXuViaOzpII=";
    };
  };

  poketcg = buildGBCRom {
    name = "poketcg";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "poketcg";
      rev = "7fb78fe0501be9923f87bced6dea5da2a2d7e116";
      sha256 = "sha256-fiGuxQVO9FDTaFwZTc2GFZaidQUGwGndigJYwUttmfA=";
    };
  };
}
