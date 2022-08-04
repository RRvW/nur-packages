{ lib
, buildPythonPackage
, fetchPypi
, cairo
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

  buildInputs = [ pango gtk3 gobject-introspection ];
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];

  pythonPath = [ hdlparse pycairo pygobject3 ];

  patches = [ ./2to3.patch ];

  postPatch = ''
    substituteInPlace setup.py --replace "use_2to3 = True," ""
  '';

  dontWrapGApps = true; # use the wrapper that is implicit in buildPythonPackage, otherwise the app will be wrapped twice

  # Workaround for bug where on nixos 22.05, pango does not gets added to GI_TYPELIB_PATH
  # This causes the pango import to fail
  preFixup =
    if lib.versionAtLeast (lib.versions.majorMinor lib.version) "22.11" then ''
      makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    '' else ''
      makeWrapperArgs+=(--set GI_TYPELIB_PATH "$GI_TYPELIB_PATH:${pango}/lib/girepository-1.0")
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
