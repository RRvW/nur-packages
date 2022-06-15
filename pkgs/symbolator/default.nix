{ lib
, buildPythonPackage
, fetchPypi
, gtk3
, pango
, pycairo
, pygobject3
, hdlparse
, pytestCheckHook
, wrapGAppsHook
, gobject-introspection
}:

buildPythonPackage rec {
  pname = "symbolator";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb25c11443536bdd9a998ed2245e143c406591b96ed236d2f2c43941f566752a";
  };

  buildInputs = [ gtk3 pango gobject-introspection ];
  nativeBuildInputs = [ wrapGAppsHook ];

  propagatedBuildInputs = [ hdlparse pycairo pygobject3 ];

  patches = [ ./2to3.patch ];

  postPatch = ''
    substituteInPlace setup.py --replace "use_2to3 = True," ""
  '';

  doCheck = true;
  checkPhase = ''
    $out/bin/symbolator --version
  '';
  meta = with lib; {
    description = "HDL symbol generator";
    homepage = "https://kevinpt.github.io/symbolator";
    license = licenses.mit;
    # maintainers = [ maintainers. ];
  };
}
