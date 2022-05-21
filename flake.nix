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

      inherit (pkgs) lib callPackage fetchFromGitHub;
      inherit (lib.debug) traceVal;
      inherit (lib.attrsets) recursiveUpdate;

      callpkg = { inherit callPackage; };
      flattenAttrList = lib.lists.foldr (a: b: lib.recursiveUpdate a b) { };

      gbaTools = callPackage ./gba/tools { };
      genesisTools = callPackage ./genesis/tools.nix { };
    in
    {
      # todo: add sameboy or mGBC runner for fun
      packages.${system} =
        (flattenAttrList [
          # gbaTools
          { inherit (genesisTools) s3p2bin; }

          (import ./pc/games.nix callpkg)

          (import ./nes/tools.nix callpkg)
          (import ./nes/games.nix callpkg)

          (import ./snes/tools.nix callpkg)
          (import ./snes/games.nix callpkg)

          # todo: scope these
          (import ./gba/games.nix pkgs)
          (import ./gbc/games.nix {
            inherit (pkgs) callPackage fetchFromGitHub;
          })

          (import ./genesis/games.nix callpkg)
        ]);
    };
}
