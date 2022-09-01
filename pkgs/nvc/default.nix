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
  version = "1.7.1";
  src = fetchFromGitHub {
    owner = "nickg";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-OcRwhhX93E8LHUeFzgjGxw6OANACOUJmY4i0JKjtHfI=";
  };

  # which is needed to find llvm-config
  nativeBuildInputs = [ pkg-config flex autoreconfHook which gettext libtool ];
  buildInputs = [ ncurses llvm libffi zlib elfutils ]; # elfutils provides libdw

  configureFlags = [
    "--disable-vhpi" # fails the internal test suite with undefined symbol
    "--disable-lto" # LTO gives errors about missing plugin
    "--enable-vital"
  ];

  checkInputs = [ check ];

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
