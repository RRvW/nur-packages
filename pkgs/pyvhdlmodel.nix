{ lib
, buildPythonPackage
, fetchPypi
, pytooling
, fetchFromGitHub
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pyvhdlmodel";
  version = "0.14.1";

  disabled = !(pythonAtLeast "3.6"); # requires python version >=3.6

  buildInputs = [ pytooling ];

  src = fetchFromGitHub {
    owner = "VHDL";
    repo = "pyVHDLModel";
    rev = "v${version}";
    sha256 = "sha256-Y+CK9Cw80HaKP3OOxEIHHWKtZhEJfbhHfSoxOoiescY=";
  };

  meta = with lib; {
    description = "An abstract VHDL language model";
    homepage = "https://GitHub.com/VHDL/pyVHDLModel";
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
