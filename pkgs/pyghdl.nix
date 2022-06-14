{ lib, ghdl, makeWrapper, buildPythonPackage, pyvhdlmodel, pytooling, pydecor }:

let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.5.0";
  }) { };

in buildPythonPackage {
  src = ghdl.src;
  pname = "pyGHDL";
  version = ghdl.version;
  paths = [ ghdl.all ];
  pythonPath = [ pydecor  pytooling pyvhdlmodel ];

  nativeBuildInputs = [ ghdl makeWrapper ];
  doCheck = false;

  configureScript = ''
    true
  '';
  postInstall = ''
    wrapProgram $out/bin/ghdl-ls --set GHDL_PREFIX ${ghdl}/lib/ghdl/
  '';
}
