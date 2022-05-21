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

      inherit (pkgs) lib callPackage;
      inherit (lib.attrsets) recursiveUpdate;

      flattenAttrList = lib.lists.foldr (a: b: lib.recursiveUpdate a b) { };

      gbaTools = import ./gba/tools pkgs;
      genesisTools = import ./genesis/builders.nix pkgs;
    in
    {
      # todo: add sameboy or mGBC runner for fun
      packages.${system} =
        { inherit (genesisTools) s3p2bin; } //
        { sm64plus = callPackage ./pc/sm64plus pkgs; } //
        (flattenAttrList [
          gbaTools
          (import ./gba/games.nix pkgs)
          (import ./gbc/games.nix pkgs)
          (import ./genesis/games.nix pkgs)
          
          (import ./nes/tools.nix pkgs)
          (import ./nes/games.nix pkgs)
        ]);
    };
}
