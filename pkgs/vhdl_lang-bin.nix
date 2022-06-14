{ lib, stdenv, autoPatchelfHook, fetchzip, ... }:

stdenv.mkDerivation rec {
  pname = "vhdl_lang";
  version = "0.18.0";
  src = fetchzip {
    url =
      "https://github.com/VHDL-LS/rust_hdl/releases/download/v${version}/${pname}-x86_64-unknown-linux-gnu.zip";
    sha256 = "0mgr01cad9zmqpwz60p29n1hvsqj6njgk6vcp3ix4sbciqb6fmkq";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    install -D bin/${pname} $out/bin/${pname}
    cp -r vhdl_libraries $out/
  '';

  meta = with lib; {
    platforms = [ "x86_64-linux" ];
  };

}
