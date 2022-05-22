{
  description = "assembling and compiling dissassembly and decompilation game projects";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      inherit (pkgs) lib callPackage callPackages fetchFromGitHub;
      inherit (lib.debug) traceVal;
      inherit (lib.attrsets) recursiveUpdate;

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

          (callPackages ./genesis/games.nix { })
          (callPackages ./genesis/tools.nix { })
        ]);
    };
}
