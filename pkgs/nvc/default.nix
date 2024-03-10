{ lib
, stdenv
, llvm
, fetchFromGitHub
, autoreconfHook
, ncurses
, pkg-config
, libffi
, flex
, check
, which
, gettext
, libtool
, zlib
, elfutils
, zstd
, enableTcl ? false
, tcl
, enableWebsocketServer ? false # requires TCL
# these need to be ran on the host, thus disable when cross-compiling
, doCheck ? stdenv.hostPlatform == stdenv.buildPlatform
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.11.3";
  src = fetchFromGitHub {
    owner = "nickg";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-Z4YxXPf8uKlASSK9v6fbtHtkUibc9EeA4i+3kD/vBmY=";
  };

  # which is needed to find llvm-config
  nativeBuildInputs = [ pkg-config flex autoreconfHook which gettext libtool ];

  # elfutils provides libdw
  buildInputs = [ ncurses llvm libffi zlib zstd.dev zstd.out elfutils ]
    ++ lib.optional enableTcl tcl
  ;

  configureFlags = [
    #    "--disable-vhpi" # fails the internal test suite with undefined symbol
    "--disable-lto" # LTO gives errors about missing plugin
    "--enable-vital"
    (lib.enableFeature enableTcl "tcl")
    (lib.enableFeature enableWebsocketServer "server")
  ];

  checkInputs = [ check ];

  # nvc requires compilation in a subdirectory
  preConfigure = ''
    mkdir build
    cd build
  '';
  configureScript = "../configure";

  inherit doCheck;
  checkPhase = ''
    make check
  '';

  meta = {
    #    broken = true;
    description = "VHDL compiler and simulator";
    homepage = "https://www.nickg.me.uk/nvc/";
    license = lib.licenses.gpl3;
  };
}
