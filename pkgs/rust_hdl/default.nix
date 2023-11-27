{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
, fetchCrate
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "rust_hdl";
  version = "0.77.0";

  broken = true; # latest version has not been uploaded to crates.io, and source does not contain cargo.lock
  # Furthermore, the vhdl_libraries folder required for operation is not bundled in the crate source

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
    sha256 = "0x66rmn0i1p84iivhppp7r0rb1afkwp4hi4nf71fdsl2y6dvh1r0";
  };

  doCheck = lib.versionAtLeast rustPlatform.rust.rustc.version "1.70.0"; # running tests requires rust > 1.70
  cargoSha256 = "sha256-lN9icvwOmXDOkPNbRyV68o18t4fKDO8giHNUSo975F8=";

  meta = with lib; {
    homepage = "https://github.com/VHDL-LS/rust_hdl";
    license = with licenses; [ mit ];
    mainProgram = "vhdl_ls";
  };
}
