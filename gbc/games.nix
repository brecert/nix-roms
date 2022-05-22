{ callPackage
, fetchFromGitHub
, mkPretRom ? callPackage ./tools/mkPretRom.nix { }
}:

{
  pokered = mkPretRom {
    name = "pokered";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokered";
      rev = "64e2b66a610d330bfdad108a603027be9652a7e7";
      sha256 = "sha256-SfStLJbh8FvwBPfF/2TZVTW9cKY8tQNAk0Li8ajeTPI=";
    };
  };

  pokeblue = mkPretRom {
    name = "pokered";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokered";
      rev = "64e2b66a610d330bfdad108a603027be9652a7e7";
      sha256 = "sha256-SfStLJbh8FvwBPfF/2TZVTW9cKY8tQNAk0Li8ajeTPI=";
    };
  };

  pokeyellow = mkPretRom {
    name = "pokeyellow";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokeyellow";
      rev = "c73b4ec86e167a8aabee0e0cb6ed6ab485fbcce2";
      sha256 = "sha256-bUv/PDFX/kYZBrfd3PjYGzHqY4sp0YOz10rovVmwZFM=";
    };
  };

  pokegold = mkPretRom {
    name = "pokegold";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokegold";
      rev = "3ce41509db5a3c95ea6cec173e79557b771857a7";
      sha256 = "sha256-xr1jaOA+dXKg2mG2aSn9B5Lxp9uJCYdPUho2TlRFJX0=";
    };
  };

  pokesilver = mkPretRom {
    name = "pokesilver";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokegold";
      rev = "3ce41509db5a3c95ea6cec173e79557b771857a7";
      sha256 = "sha256-xr1jaOA+dXKg2mG2aSn9B5Lxp9uJCYdPUho2TlRFJX0=";
    };
  };

  pokecrystal = mkPretRom {
    name = "pokecrystal";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokecrystal";
      rev = "fbcc8d1b0e05cace2abe2083a88a8c2304efc9d7";
      sha256 = "sha256-UY6oLESmDHJgat4Qnsk/67cqgYz08dgSTTmRHgFYfKE=";
    };
  };

  pokepinball = mkPretRom {
    name = "pokepinball";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokepinball";
      rev = "14c3e9b94f8d920101f39e724abcb122b44f4aea";
      sha256 = "sha256-DNd7+tBi6JKffxuuABSzp41E1GF45dyxyXuViaOzpII=";
    };
  };

  poketcg = mkPretRom {
    name = "poketcg";
    src = fetchFromGitHub {
      owner = "pret";
      repo = "poketcg";
      rev = "7fb78fe0501be9923f87bced6dea5da2a2d7e116";
      sha256 = "sha256-fiGuxQVO9FDTaFwZTc2GFZaidQUGwGndigJYwUttmfA=";
    };
  };

  # todo: dry?
  ladx-azlj = callPackage ./games/ladx/rom.nix { romName = "azlj"; version = "1.0"; };
  ladx-azlj-r1 = callPackage ./games/ladx/rom.nix { romName = "azlj-r1"; version = "1.1"; };
  ladx-azlj-r2 = callPackage ./games/ladx/rom.nix { romName = "azlj-r2"; version = "1.2"; };

  ladx-azle = callPackage ./games/ladx/rom.nix { romName = "azle"; version = "1.0"; };
  ladx-azle-r1 = callPackage ./games/ladx/rom.nix { romName = "azle-r1"; version = "1.1"; };
  ladx-azle-r2 = callPackage ./games/ladx/rom.nix { romName = "azle-r2"; version = "1.2"; };

  ladx-azlg = callPackage ./games/ladx/rom.nix { romName = "azlg"; version = "1.0"; };
  ladx-azlg-r1 = callPackage ./games/ladx/rom.nix { romName = "azlg-r1"; version = "1.1"; };

  ladx-azlf = callPackage ./games/ladx/rom.nix { romName = "azlf"; version = "1.0"; };
  ladx-azlf-r1 = callPackage ./games/ladx/rom.nix { romName = "azlf-r1"; version = "1.1"; };
}
