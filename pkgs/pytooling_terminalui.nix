{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pytooling
, colorama
}:

buildPythonPackage rec {
  pname = "pytooling-terminalui";
  version = "1.5.8"; # version 1.5.9 required colorama >= 0.4.5, which is not in nixos-22.05

  disabled = !(pythonAtLeast "3.7"); # requires python version >=3.7
  propagatedBuildInputs = [ pytooling colorama ];
  src = fetchFromGitHub {
    repo = "pyTooling.TerminalUI";
    owner = "pyTooling";
    rev = "v${version}";
    sha256 = "0l3m4d8jy8gb8p00099lfghq241bplayz4rwrfmkhcybpbq84bz7";
  };

  meta = with lib; {
    description = "A set of helpers to implement a text user interface (TUI) in a terminal";
    homepage = https://GitHub.com/pyTooling/pyTooling.TerminalUI;
    license = licenses.asl20;
    # maintainers = [ maintainers. ];
  };
}
