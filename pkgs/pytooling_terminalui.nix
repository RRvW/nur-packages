{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pytooling
, colorama
}:

buildPythonPackage rec {
  pname = "pytooling-terminalui";
  version = "1.5.9"; # version 1.5.9 required colorama >= 0.4.5, which is not in nixos-22.05

  disabled = !(pythonAtLeast "3.7"); # requires python version >=3.7
  propagatedBuildInputs = [ pytooling colorama ];
  src = fetchFromGitHub {
    repo = "pyTooling.TerminalUI";
    owner = "pyTooling";
    rev = "v${version}";
    sha256 = "sha256-UOx+ju+8S2sUQ4ZF2rbw/aF/B4wrzSbstotWtjYmhno=";
  };

  meta = with lib; {
    description = "A set of helpers to implement a text user interface (TUI) in a terminal";
    homepage = https://GitHub.com/pyTooling/pyTooling.TerminalUI;
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
