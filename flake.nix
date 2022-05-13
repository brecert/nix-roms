{
  description = "assembling and compiling dissassembly and decompilation game projects";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit(pkgs) lib stdenv;
    
    buildGBCRom = { name, src, ... }@attrs:
      stdenv.mkDerivation ({
        inherit name src;
        buildInputs = with pkgs; [
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

    packages = {
      # devkitarm = {};

      # gba c compiler for pret projects
      # agbcc = stdenv.mkDerivation {}

      pokeredblue = buildGBCRom {
        name = "pokeredblue";
        src = pkgs.fetchFromGitHub {
          owner = "pret";
          repo = "pokered";
          rev = "64e2b66a610d330bfdad108a603027be9652a7e7";
          sha256 = "sha256-SfStLJbh8FvwBPfF/2TZVTW9cKY8tQNAk0Li8ajeTPI=";
        }; 
        installPhase = ''
          mkdir $out
          mv pokered.gbc $out/pokered.gbc
          mv pokeblue.gbc $out/pokeblue.gbc
        '';
      };

      pokeyellow = buildGBCRom {
        name = "pokeyellow";
        src = pkgs.fetchFromGitHub {
          owner = "pret";
          repo = "pokeyellow";
          rev = "c73b4ec86e167a8aabee0e0cb6ed6ab485fbcce2";
          sha256 = "sha256-bUv/PDFX/kYZBrfd3PjYGzHqY4sp0YOz10rovVmwZFM=";
        };
      };

      pokegold = buildGBCRom {
        name = "pokegold";
        src = pkgs.fetchFromGitHub {
          owner = "pret";
          repo = "pokegold";
          rev = "3ce41509db5a3c95ea6cec173e79557b771857a7";
          sha256 = "sha256-xr1jaOA+dXKg2mG2aSn9B5Lxp9uJCYdPUho2TlRFJX0=";
        };
      };

      pokecrystal = buildGBCRom {
        name = "pokecrystal";
        src = pkgs.fetchFromGitHub {
          owner = "pret";
          repo = "pokecrystal";
          rev = "fbcc8d1b0e05cace2abe2083a88a8c2304efc9d7";
          sha256 = "sha256-UY6oLESmDHJgat4Qnsk/67cqgYz08dgSTTmRHgFYfKE=";
        };
      };

      pokepinball = buildGBCRom {
        name = "pokepinball";
        src = pkgs.fetchFromGitHub {
          owner = "pret";
          repo = "pokepinball";
          rev = "14c3e9b94f8d920101f39e724abcb122b44f4aea";
          sha256 = "sha256-DNd7+tBi6JKffxuuABSzp41E1GF45dyxyXuViaOzpII=";
        };
      };

      poketcg = buildGBCRom {
        name = "poketcg";
        src = pkgs.fetchFromGitHub {
          owner = "pret";
          repo = "poketcg";
          rev = "7fb78fe0501be9923f87bced6dea5da2a2d7e116";
          sha256 = "sha256-fiGuxQVO9FDTaFwZTc2GFZaidQUGwGndigJYwUttmfA=";
        };
      };
      
    };
  in
  {
    # todo: add sameboy or mGBC runner for fun
    packages.${system} = packages;
  };
}
