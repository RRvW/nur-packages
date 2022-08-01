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
  patches = [
    (fetchpatch {
      name = "fix-ghdl-dom-singleton-import.patch";
      url =
        "https://github.com/ghdl/ghdl/commit/e35bc1bd8b4a60e5a3c18aeb5e8747a123c5a13b.patch";
      sha256 = "sha256-ozY9QE4sP3yPcX1tEXVO/7AKQpMDIYLVKGF7h8ttVWQ=";
    })

  ];
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
