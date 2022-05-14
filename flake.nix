{
  description = "assembling and compiling dissassembly and decompilation game projects";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      inherit (pkgs) lib stdenv callPackage;
      inherit (lib) lists attrsets;
      inherit (attrsets) recursiveUpdate;

      flattenAttrList = lib.lists.foldr (a: b: lib.recursiveUpdate a b) { };

      gbaTools = import ./gba/tools pkgs;
    in
    {
      # todo: add sameboy or mGBC runner for fun
      packages.${system} = flattenAttrList [
        gbaTools
        (import ./gba/games.nix pkgs)
        (import ./gbc/games.nix pkgs)
      ];
    };
}
