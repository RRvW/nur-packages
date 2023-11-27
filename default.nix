# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  ghdl-mcode = pkgs.callPackage ./pkgs/ghdl { backend = "mcode"; };
  ghdl-llvm = pkgs.callPackage ./pkgs/ghdl { backend = "llvm"; llvm = pkgs.llvmPackages_14.llvm; };
  ghdl = ghdl-mcode;
  nvc = pkgs.callPackage ./pkgs/nvc { };

  vhdl_ls-bin = pkgs.callPackage ./pkgs/vhdl_ls-bin.nix { };
  vhdl_lang-bin = pkgs.callPackage ./pkgs/vhdl_lang-bin.nix { };
  # rust_hdl = pkgs.callPackage ./pkgs/rust_hdl {}; # broken

  python3Packages = pkgs.recurseIntoAttrs rec {
    pytooling = pkgs.python3.pkgs.callPackage ./pkgs/pytooling.nix { };
    pytoolingTerminalUI = pkgs.python3.pkgs.callPackage ./pkgs/pytooling_terminalui.nix { inherit pytooling; };
    pyattributes = pkgs.python3.pkgs.callPackage ./pkgs/pyattributes.nix { inherit pytooling; };
    pyvhdlmodel = pkgs.python3.pkgs.callPackage ./pkgs/pyvhdlmodel.nix {
      inherit pytooling;
    };
    pydecor = pkgs.python3.pkgs.callPackage ./pkgs/pydecor.nix { };
    pyghdl = pkgs.python3.pkgs.callPackage ./pkgs/pyghdl.nix {
      inherit pyvhdlmodel pytooling pydecor pytoolingTerminalUI pyattributes ghdl;
    };
    pyghdl-mcode = pyghdl;
    pyghdl-llvm = pyghdl.override { ghdl = ghdl-llvm; }; # ghdl-llvm seems to be broken in nixpkgs :(

    # HDLParse has been yanked from nixpkgs for using removed setuptools options
    hdlparse = pkgs.python3.pkgs.callPackage ./pkgs/hdlparse { };
    symbolator =
      pkgs.python3.pkgs.callPackage ./pkgs/symbolator { hdlparse = hdlparse; };
    hdl_checker = pkgs.python3.pkgs.callPackage ./pkgs/hdl_checker.nix { };
  };

  hdl_checker = python3Packages.hdl_checker;
  symbolator = python3Packages.symbolator;

}
