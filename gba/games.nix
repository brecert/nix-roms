{ lib
, callPackage
, fetchFromGitHub
, mkPretRom ? callPackage ./tools/mkPretRom.nix { }
}:

let
  mkPokeRuby = { romName, ... }@attrs:
    mkPretRom ({
      inherit romName;

      src = fetchFromGitHub {
        owner = "pret";
        repo = "pokeruby";
        rev = "1380ad46772737fd9a21a4ff4be9f61d81b59c4b";
        sha256 = "sha256-4SV0qMa4B1oUehCAvgCv/uvni9TFDIUuSgLE15Z4mkc=";
      };

      installPhase = ''
        runHook preInstall

        mv poke$romName.gba $out

        runHook postInstall
      '';
    } // attrs);

  mkPokeFireRed = { romName, ... }@attrs:
    mkPretRom ({
      inherit romName;

      src = fetchFromGitHub {
        owner = "pret";
        repo = "pokefirered";
        rev = "0ef73070401817add41f79cb8ad2a89077e272b7";
        sha256 = "sha256-lN0W/mF/I4PAsqNz68d+x+/rkVAQJkhnJ8892B12uGU=";
      };

      installPhase = ''
        runHook preInstall

        mv poke$romName.gba $out

        runHook postInstall
      '';
    } // attrs);
in

{
  gameboy-tetris = callPackage ./games/tetris { };

  # todo: separate poke
  # todo: dry?
  pokeruby = mkPokeRuby {
    name = "pokeruby";
    romName = "ruby";
  };
  pokeruby_rev1 = mkPokeRuby {
    pname = "pokeruby";
    version = "rev1";
    romName = "ruby_rev1";
  };
  pokeruby_rev2 = mkPokeRuby {
    pname = "pokeruby";
    version = "rev2";
    romName = "ruby_rev2";
  };
  pokesapphire = mkPokeRuby {
    name = "pokesapphire";
    romName = "sapphire";
  };
  pokesapphire_rev1 = mkPokeRuby {
    pname = "pokesapphire";
    version = "rev1";
    romName = "sapphire_rev1";
  };
  pokesapphire_rev2 = mkPokeRuby {
    pname = "pokesapphire";
    version = "rev2";
    romName = "sapphire_rev2";
  };

  pokefirered = mkPokeFireRed {
    name = "pokefirered";
    romName = "firered";
  };
  pokefirered_rev1 = mkPokeFireRed {
    pname = "pokefirered";
    version = "rev1";
    romName = "firered_rev1";
  };
  pokeleafgreen = mkPokeFireRed {
    name = "pokeleafgreen";
    romName = "leafgreen";
  };
  pokeleafgreen_rev1 = mkPokeFireRed {
    pname = "pokeleafgreen";
    version = "rev1";
    romName = "leafgreen_rev1";
  };

  pokeemerald = mkPretRom {
    name = "pokeemerald";
    romName = null;

    src = fetchFromGitHub {
      owner = "pret";
      repo = "pokeemerald";
      rev = "7d2344c07bea9a46993a92d4611fba80545acdd2";
      sha256 = "sha256-S9KxF79Ft1VBzlAR4as6+zR03ERwe2Jmhgbt79cpuJE=";
    };

    postBuild = ''
      # we already have the tools so we disable tool building
      substituteInPlace Makefile \
          --replace "$(MAKE) -f make_tools.mk" ""
    '';

    installPhase = ''
      runHook preInstall

      mv pokeemerald.gba $out

      runHook postInstall
    '';
  };
}
