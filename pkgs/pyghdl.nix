{ lib, ghdl, makeWrapper, buildPythonPackage, pyvhdlmodel, pytooling, pydecor }:

buildPythonPackage {
  src = ghdl.src;
  pname = "pyGHDL";
  version = ghdl.version;
  paths = [ ghdl.all ];
  pythonPath = [ pydecor pytooling pyvhdlmodel ];

  nativeBuildInputs = [ ghdl makeWrapper ];
  doCheck = false;

  configureScript = ''
    true
  '';
  postInstall = ''
    wrapProgram $out/bin/ghdl-ls --set GHDL_PREFIX ${ghdl}/lib/ghdl/
  '';
}
