{ lib
, ghdl
, fetchpatch
, makeWrapper
, buildPythonPackage
, pyvhdlmodel
, pytooling
, pydecor
, pytoolingTerminalUI
, pyattributes
}:

buildPythonPackage {
  src = ghdl.src;

  pname = "pyGHDL";
  version = ghdl.version;
  paths = [ ghdl.all ];
  pythonPath =
    [ pydecor pytooling pyvhdlmodel pytoolingTerminalUI pyattributes ];

  nativeBuildInputs = [ ghdl makeWrapper ];
  doCheck = false;

  configureScript = ''
    true
  '';
  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --set GHDL_PREFIX ${ghdl}/lib/ghdl/
    done
  '';
}
