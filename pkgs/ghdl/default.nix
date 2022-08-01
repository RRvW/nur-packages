{ gcc11Stdenv
, fetchFromGitHub
, fetchpatch
, callPackage
, gnat
, zlib
, llvm
, lib
, backend ? "mcode"
}:

assert backend == "mcode" || backend == "llvm";

let stdenv = gcc11Stdenv;

in
stdenv.mkDerivation rec {
  pname = "ghdl-${backend}";
  version = "2.0.0";



  src = fetchFromGitHub {
    owner = "ghdl";
    repo = "ghdl";
    rev = "v${version}";
    sha256 = "sha256-B/G3FGRzYy4Y9VNNB8yM3FohiIjPJhYSVbqsTN3cL5k=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc-12-compilation.patch";
      url =
        "https://github.com/ghdl/ghdl/commit/f8b87697e8b893b6293ebbfc34670c32bfb49397.patch";
      sha256 = "sha256-tVbMm8veFkNPs6WFBHvaic5Jkp1niyg0LfFufa+hT/E=";
    })
    (fetchpatch {
      name = "fix-gcc-12-pragmas.patch";
      url = "https://github.com/ghdl/ghdl/commit/8c5689b93e68ac34cdf7dd089a3990ae22f0049c.patch";
      sha256 = "sha256-O3heXNSUwBO2127nj5KR3O9SWveOvOit6hYOJv6yG08=";

    })
  ];

  LIBRARY_PATH = "${stdenv.cc.libc}/lib";

  buildInputs = [ gnat zlib ] ++ lib.optional (backend == "llvm") [ llvm ];
  propagatedBuildInputs = lib.optionals (backend == "llvm") [ zlib ];

  preConfigure = ''
    # If llvm 7.0 works, 7.x releases should work too.
    sed -i 's/check_version  7.0/check_version  7/g' configure
  '';

  configureFlags = [ "--enable-synth" ] ++ lib.optional (backend == "llvm")
    "--with-llvm-config=${llvm.dev}/bin/llvm-config";

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = let
    ghdl = "./ghdl_${backend}";
  in ''
    export PATH+=":$PWD"
    ls
    pwd
    ls *
    cp ${./simple.vhd} simple.vhd
    cp ${./simple-tb.vhd} simple-tb.vhd
    mkdir -p ghdlwork
    ${ghdl} -a --workdir=ghdlwork --ieee=synopsys simple.vhd simple-tb.vhd
    ${ghdl} -e --workdir=ghdlwork --ieee=synopsys -o sim-simple tb
  '' + (if backend == "llvm" then ''
    ./sim-simple --assert-level=warning > output.txt
  '' else ''
    ${ghdl} -r --workdir=ghdlwork --ieee=synopsys tb > output.txt
  '') + ''
    diff output.txt ${./expected-output.txt}
  '';


  meta = with lib; {
    broken = (lib.versionAtLeast gnat.version "12.0") || (lib.versionAtLeast llvm.version "14.1");
    homepage = "https://github.com/ghdl/ghdl";
    description = "VHDL 2008/93/87 simulator";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
