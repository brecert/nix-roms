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

      callpkg = { inherit callPackage; };
      flattenAttrList = lib.lists.foldr (a: b: lib.recursiveUpdate a b) { };

      genesisTools = callPackage ./genesis/tools.nix { };
    in
    {
      # todo: add sameboy or mGBC runner for fun
      packages.${system} =
        (flattenAttrList [
          (callPackages ./gba/tools.nix { })
          { inherit (genesisTools) s3p2bin; }

          (import ./pc/games.nix callpkg)

          (import ./nes/tools.nix callpkg)
          (import ./nes/games.nix callpkg)

          (import ./snes/tools.nix callpkg)
          (import ./snes/games.nix callpkg)

          # todo: scope these
          (callPackages ./gba/games.nix { })
          (callPackages ./gba/tools.nix { })
          (callPackages ./gbc/games.nix { })

          (import ./genesis/games.nix callpkg)
        ]);
    };
}
