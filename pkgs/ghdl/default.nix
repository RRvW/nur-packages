{ stdenv
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



stdenv.mkDerivation rec {
  pname = "ghdl-${backend}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ghdl";
    repo = "ghdl";
    rev = "v${version}";
    sha256 = "sha256-94RNtHbOpbC2q/Z+PsQplrLxXmpS3LXOCXyTBB+n9c4=";
  };

  LIBRARY_PATH = "${stdenv.cc.libc}/lib";

  buildInputs = [ gnat zlib ] ++ lib.optional (backend == "llvm") [ llvm ];
  propagatedBuildInputs = lib.optionals (backend == "llvm") [ zlib ];

  preConfigure = ''
    # If llvm 7.0 works, 7.x releases should work too.
    sed -i 's/check_version  7.0/check_version  7/g' configure
  '';

  configureFlags = [ "--enable-synth" "--disable-werror" ] ++ lib.optional (backend == "llvm")
    "--with-llvm-config=${llvm.dev}/bin/llvm-config";

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase =
    let
      ghdl = "./ghdl_${backend}";
    in
    ''
      export PATH+=":$PWD"
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
      diff -q output.txt ${./expected-output.txt}
    '';


  meta = with lib; {
    broken = backend == "llvm" && (lib.versionAtLeast llvm.version "14.1");
    homepage = "https://github.com/ghdl/ghdl";
    description = "VHDL 2008/93/87 simulator";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
