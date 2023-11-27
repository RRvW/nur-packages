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
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.8.2";
  src = fetchFromGitHub {
    owner = "nickg";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-s7QgufD3sQ6sZh2H78E8x0dMidHRKHUm8tASXoKK3xk=";
  };

  # which is needed to find llvm-config
  nativeBuildInputs = [ pkg-config flex autoreconfHook which gettext libtool ];
  buildInputs = [ ncurses llvm libffi zlib elfutils ]; # elfutils provides libdw

  configureFlags = [
    #    "--disable-vhpi" # fails the internal test suite with undefined symbol
    "--disable-lto" # LTO gives errors about missing plugin
    "--enable-vital"
  ];

  checkInputs = [ check ];
  broken = true;
  configurePhase = ''
    mkdir build
    cd build
    ../configure $configureFlags

  '';

  doCheck = true;
  checkPhase = ''
    make check
  '';

  meta = {
    description = "VHDL compiler and simulator";
    homepage = "https://www.nickg.me.uk/nvc/";
    license = lib.licenses.gpl3;
  };
}
