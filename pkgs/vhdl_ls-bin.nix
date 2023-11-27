{ lib, stdenv, pkgs, autoPatchelfHook, fetchzip, ... }:

stdenv.mkDerivation rec {
  pname = "vhdl_ls";
  version = "0.18.0";
  src = fetchzip {
    url =
      "https://github.com/VHDL-LS/rust_hdl/releases/download/v${version}/vhdl_ls-x86_64-unknown-linux-gnu.zip";
    sha256 = "1h9kyiiiz00bvih65sspjvirq6rbsgj24q4l0agd7n98ssn3rfgc";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  broken = true; # cannot find libgcc_s.so.1
  installPhase = ''
    mkdir $out
    cp -r * $out
  '';
}
