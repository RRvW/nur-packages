{ lib, stdenv, autoPatchelfHook, fetchzip, gcc, glibc }:

stdenv.mkDerivation rec {
  pname = "vhdl_lang";
  version = "0.77.0";
  src = fetchzip {
    url =
      "https://github.com/VHDL-LS/rust_hdl/releases/download/v${version}/${pname}-x86_64-unknown-linux-gnu.zip";
    sha256 = "0f71sla1pr32xrz2a1vmanb831alzrdjwla5lm722rdkmcvdfjs3";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ gcc glibc ];
  dontConfigure = true;
  broken = true; # cannot find libgcc_s.so.1
  dontBuild = true;
  installPhase = ''
    install -D bin/${pname} $out/bin/${pname}
    cp -r vhdl_libraries $out/
  '';

  meta = with lib; {
    platforms = [ "x86_64-linux" ];
  };

}
