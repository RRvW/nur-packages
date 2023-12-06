{ lib
, buildPythonPackage
, fetchPypi
, pytooling
, fetchFromGitHub
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pyvhdlmodel";
  version = "0.23.0";

  disabled = !(pythonAtLeast "3.6"); # requires python version >=3.6

  buildInputs = [ pytooling ];

  doCheck = false; # test broken somehow

  src = fetchFromGitHub {
    owner = "VHDL";
    repo = "pyVHDLModel";
    rev = "v${version}";
    sha256 = "sha256-HrIu9lId3HgoN79pN9EjdsA4Z5ky7d3colVpllScu0Q=";
  };

  meta = with lib; {
    description = "An abstract VHDL language model";
    homepage = "https://GitHub.com/VHDL/pyVHDLModel";
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
