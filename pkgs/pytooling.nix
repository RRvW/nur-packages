{ lib
, buildPythonPackage
, ruamel-yaml
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pytooling";
  version = "2.0.1";

  disabled = !(pythonAtLeast "3.7"); # requires python version >=3.7

  buildInputs = [ ruamel-yaml ];

  # We have to build from source, since the PyPi files do not contain a requirements file
  # If this file is absent the build process crashes
  src = fetchFromGitHub {
    owner = "pyTooling";
    repo = "pyTooling";
    rev = "v${version}";
    sha256 = "0k535ny2rxi08db42h9d3d268zx1mwf23mqqpbjijp2w0isfrr3h";
  };

  doCheck =
    false; # tests seem to expect to import random packages, not sure how to fix
  checkInputs = [ pytestCheckHook ];
  meta = with lib; {
    description =
      "PyTooling is a powerful collection of arbitrary useful classes, decorators, meta-classes and exceptions";
    homepage = "https://GitHub.com/pyTooling/pyTooling";
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
