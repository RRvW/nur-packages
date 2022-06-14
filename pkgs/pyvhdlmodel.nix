{ lib, buildPythonPackage, fetchPypi, pytooling, fetchFromGitHub, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pyvhdlmodel";
  version = "0.14.3";

  disabled = !(pythonAtLeast "3.6"); # requires python version >=3.6

  buildInputs = [ pytooling ];

  src = fetchFromGitHub {
    owner = "VHDL";
    repo = "pyVHDLModel";
    rev = "v${version}";
    sha256 = "0rh3c5060c25z6541jv7xvgrp3cq06n2q3v24pdc5ncxfzlizl9r";
  };

  meta = with lib; {
    description = "An abstract VHDL language model";
    homepage = "https://GitHub.com/VHDL/pyVHDLModel";
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
