# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  vhdl_ls-bin = pkgs.callPackage ./pkgs/vhdl_ls-bin.nix { };
  vhdl_lang-bin = pkgs.callPackage ./pkgs/vhdl_lang-bin.nix { };
  # rust_hdl = pkgs.callPackage ./pkgs/rust_hdl {}; # broken

  python3Packages = pkgs.recurseIntoAttrs rec {
    pytooling = pkgs.python3.pkgs.callPackage ./pkgs/pytooling.nix { };
    pyvhdlmodel = pkgs.python3.pkgs.callPackage ./pkgs/pyvhdlmodel.nix {
      inherit pytooling;
    };
    pydecor = pkgs.python3.pkgs.callPackage ./pkgs/pydecor.nix {};
    pyghdl = pkgs.python3.pkgs.callPackage ./pkgs/pyghdl.nix {
      inherit pyvhdlmodel pytooling pydecor;
    };
    pyghdl-mcode = pyghdl;
    # pyghdl-llvm = pyghdl.override {ghdl = pkgs.ghdl-llvm; }; # ghdl-llvm seems to be broken in nixpkgs :(

  };
  hdl_checker = pkgs.python3.pkgs.callPackage ./pkgs/hdl_checker.nix {};
  symbolator = pkgs.python3.pkgs.callPackage ./pkgs/symbolator.nix {};
}
