{ lib
, buildPythonPackage
, ruamel-yaml
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pytooling";
  version = "2.12.3";

  disabled = !(pythonAtLeast "3.7"); # requires python version >=3.7

  buildInputs = [ ruamel-yaml ];

  # We have to build from source, since the PyPi files do not contain a requirements file
  # If this file is absent the build process crashes
  src = fetchFromGitHub {
    owner = "pyTooling";
    repo = "pyTooling";
    rev = "v${version}";
    sha256 = "sha256-ESdt266rFLQ3/7DA1LKYPQItOepQtR1GdV+RVjDn4Ws=";
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
