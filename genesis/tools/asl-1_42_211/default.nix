# SPDX-License-Identifier: MIT
# adapted from https://github.com/NixOS/nixpkgs/blob/nixos-21.11/pkgs/development/compilers/asl/default.nix

{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "asl";
  version = "142-bld89";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "http://john.ccac.rwth-aachen.de:8000/ftp/as/source/c_version/asl-current-${version}.tar.bz2";
    hash = "sha256-nq/0HWGOgfYIB22Xdke7VtrFB58L4oZE80N9vXG6jCI=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "all: binaries docs" "all: binaries"
  '';

  dontConfigure = true;

  preBuild = ''
    bindir="${placeholder "out"}/bin" \
    docdir="${placeholder "out"}/doc/asl" \
    incdir="${placeholder "out"}/include/asl" \
    libdir="${placeholder "out"}/lib/asl" \
    mandir="${placeholder "out"}/share/man" \
    substituteAll ${./Makefile-nixos.def} Makefile.def
    mkdir -p .objdir
  '';

  meta = with lib; {
    homepage = "http://john.ccac.rwth-aachen.de:8000/as/index.html";
    description = "Portable macro cross assembler";
    longDescription = ''
      AS is a portable macro cross assembler for a variety of microprocessors
      and -controllers. Though it is mainly targeted at embedded processors and
      single-board computers, you also find CPU families in the target list that
      are used in workstations and PCs.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
