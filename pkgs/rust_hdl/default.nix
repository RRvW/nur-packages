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
  version = "0.78.1";

  broken = true; # latest version has not been uploaded to crates.io, and source does not contain cargo.lock
  # Furthermore, the vhdl_libraries folder required for operation is not bundled in the crate source

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
    sha256 = "sha256-LY9lFZe8MFuDwtNbi9D4JiYY+xKb5bGBHGnH951oRiQ=";
  };

  doCheck = lib.versionAtLeast rustPlatform.rust.rustc.version "1.70.0"; # running tests requires rust > 1.70
  cargoSha256 = "sha256-TdsGymW2nVn1MmrDfBP9pcAhlDFRv2rrl85nQ46IRnM=";

  meta = with lib; {
    homepage = "https://github.com/VHDL-LS/rust_hdl";
    license = with licenses; [ mit ];
    mainProgram = "vhdl_ls";
  };
}
