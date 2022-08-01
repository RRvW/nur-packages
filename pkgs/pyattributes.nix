{ lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, fetchPypi
, pytooling
, argcomplete
}:

buildPythonPackage rec {
  pname = "pyattributes";
  version = "2.5.1";

  disabled = !(pythonAtLeast "3.7"); # requires python version >=3.7

  propagatedBuildInputs = [ argcomplete pytooling ];
  src = fetchFromGitHub {
    repo = "pyAttributes";
    owner = "pyTooling";
    rev = "v${version}";
    sha256 = "1h1aasr28bcp78q4rbmzabjqlh9shl8q7bl50rsyrnkc9pba3yl2";
  };

  meta = with lib; {
    description = "NET-like Attributes implemented as Python decorators";
    homepage = "https://GitHub.com/pyTooling/pyAttributes";
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
