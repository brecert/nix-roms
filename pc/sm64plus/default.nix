# SPDX-License-Identifier: MIT
# adapted from https://github.com/NixOS/nixpkgs/blob/nixos-21.11/pkgs/games/sm64ex/default.nix
{ lib
, stdenv
, fetchFromGitHub
, symlinkJoin
, python3
, rsync
, git
, pkg-config
, audiofile
, SDL2
, hexdump
, libusb1
, libXrandr
, requireFile
, compileFlags ? [ ]
, region ? "us"
, baseRom ? (requireFile {
    name = "baserom.${region}.z64";
    message = ''
      This nix expression requires that baserom.${region}.z64 is
      already part of the store. To get this file you can dump your Super Mario 64 cartridge's contents
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
      Note that if you are not using a US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
    '';
    sha256 = {
      "us" = "17ce077343c6133f8c9f2d6d6d9a4ab62c8cd2aa57c40aea1f490b4c8bb21d91";
      "eu" = "c792e5ebcba34c8d98c0c44cf29747c8ee67e7b907fcc77887f9ff2523f80572";
      "jp" = "9cf7a80db321b07a8d461fe536c02c87b7412433953891cdec9191bfad2db317";
    }.${region};
  })
, baseAssets ? null
, ...
}:

stdenv.mkDerivation rec {
  pname = "sm64plus";
  version = "master";

  src = fetchFromGitHub {
    owner = "MorsGames";
    repo = "sm64plus";
    rev = "8c66d31ea8616c88b883535a8ce36d22ac5b4996";
    sha256 = "sha256-v/DHl8z/PylBoPhgQvF2wT0Dq3jW8Vs/cHtlrBB/qlw=";
  };

  nativeBuildInputs = [ python3 pkg-config ];
  buildInputs = [ audiofile SDL2 hexdump libusb1 libXrandr ];

  makeFlags = [ "VERSION=${region}" ] ++ compileFlags
    ++ lib.optionals stdenv.isDarwin [ "OSX_BUILD=1" ];

  enableParallelBuilding = true;

  inherit baseRom region;

  preBuild = ''
    patchShebangs extract_assets.py
    ln -s $baseRom baserom.${region}.z64
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/${region}_pc/sm64.${region}.f3dex2e $out/bin/sm64plus
  '';

  meta = with lib; {
    homepage = "https://github.com/MorsGames/sm64plus";
    description = "Super Mario 64 port based off of decompilation";
    longDescription = ''
      Super Mario 64 port based off of decompilation.
      Note that you must supply a baserom yourself to extract assets from.
      If you are not using an US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
      If you would like to use patches sm64plus distributes as makeflags, add them to the "compileFlags" attribute.
    '';
    license = licenses.unfree;
    platforms = platforms.unix;
  };
}
