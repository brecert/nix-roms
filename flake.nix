{
  description = "nix derivations for misc decompilation projects";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      inherit (pkgs) lib callPackages;

      flattenAttrList = lib.lists.foldr (a: b: lib.recursiveUpdate a b) { };
    in
    {
      # todo: add sameboy or mGBC runner for fun
      packages.${system} =
        (flattenAttrList [
          (callPackages ./pc/games.nix { })

          (callPackages ./nes/tools.nix { })
          (callPackages ./nes/games.nix { })

          (callPackages ./snes/tools.nix { })
          (callPackages ./snes/games.nix { })

          (callPackages ./gba/tools.nix { })
          (callPackages ./gba/games.nix { })

          (callPackages ./gbc/games.nix { })

          (callPackages ./master_system/games.nix { })

          (callPackages ./genesis/games.nix { })
          (callPackages ./genesis/tools.nix { })
        ]);
    };
}
