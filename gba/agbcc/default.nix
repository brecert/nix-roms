{ stdenvNoCC
, fetchFromGitHub
, fetchpatch
, gcc
, gcc-arm-embedded-8
, bintools-unwrapped
, bash
, ...
}:

let
  arm-none-eabi-binutils = bintools-unwrapped.overrideAttrs (super: rec {
    pname = "arm-none-eabi-binutils";
    configureFlags = super.configureFlags ++ [
      "--target=arm-none-eabi"
      "--program-prefix=arm-none-eabi-"
    ];
    doInstallCheck = false;
  });
in

stdenvNoCC.mkDerivation {
  name = "agbcc";
  src = fetchFromGitHub {
    owner = "pret";
    repo = "agbcc";
    rev = "faa413eb0e76fad87875b7680f77e0c43df694cd";
    sha256 = "sha256-QgjAQ/n2Cnh3VyLdGiuBveTJYNitp3MLsFD7blpQo0o=";

    meta = {
      homepage = "https://github.com/pret/agbcc";
      description = "c compiler";
    };
  };

  patches = [
    (fetchpatch {
      name = "format-security.patch";
      url = "https://github.com/brecert/agbcc/commit/bae7887399aecce29fe62955775aaa4a44e5e54a.patch";
      sha256 = "sha256-lcqoJbEuN3BRtFXfHNRl7+j+Dkkckl9GqEyLe1AcwMo=";
    })
  ];

  nativeBuildInputs = [
    gcc
    gcc-arm-embedded-8
    arm-none-eabi-binutils
    bash
  ];

  doFixup = false;

  postPatch = ''
    substituteInPlace libc/Makefile \
        --replace /bin/bash ${bash}/bin/bash
  '';

  buildPhase = ''
    make -C gcc old
    mv gcc/old_agbcc .

    make -C gcc clean
    make -C gcc
    mv gcc/agbcc .

    rm -f gcc_arm/config.status gcc_arm/config.cache
    cd gcc_arm && ./configure --target=arm-elf --host=i386-linux-gnu && make cc1 && cd ..
    mv gcc_arm/cc1 agbcc_arm

    make -C libgcc
    mv libgcc/libgcc.a .

    make -C libc
    mv libc/libc.a .
  '';

  installPhase = ''
    mkdir -p $out/bin $out/include $out/lib

    mv agbcc $out/bin/
    mv old_agbcc $out/bin/
    mv agbcc_arm $out/bin/

    mv libc/include $out
    mv ginclude/* $out/include/

    mv libgcc.a $out/lib
    mv libc.a $out/lib
  '';
}
