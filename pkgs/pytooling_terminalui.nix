{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pytooling
, colorama
}:

buildPythonPackage rec {
  pname = "pytooling-terminalui";
  version = "1.5.9";

  disabled = !(pythonAtLeast "3.7"); # requires python version >=3.7
  propagatedBuildInputs = [ pytooling colorama ];
  src = fetchFromGitHub {
    repo = "pyTooling.TerminalUI";
    owner = "pyTooling";
    rev = "v${version}";
    sha256 = "0yl64qvbcmlbnvn2dk9bih3pz8gxy2vdlic68ca6njxwxy77xv2h";
  };

  meta = with lib; {
    description = "A set of helpers to implement a text user interface (TUI) in a terminal";
    homepage = https://GitHub.com/pyTooling/pyTooling.TerminalUI;
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
