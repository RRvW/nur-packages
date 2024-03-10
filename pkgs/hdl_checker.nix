{ lib
, buildPythonApplication
, fetchFromGitHub
, python3Packages
, pytestCheckHook
, ghdl
, pygls
}:

buildPythonApplication rec {
  pname = "hdl_checker";
  version = "0.7.4";
  src = fetchFromGitHub {
    owner = "suoto";
    repo = pname;
    rev = "v${version}";
    sha256 = "09qiaybdw28ix9yy2qzhvqz1z4k46hlhbw7lwi213ykpqi6cln49";
  };

  # typing & argparse are built into the stdlib
  # Requests has a pretty stable API, so later versions should be OK
  # pygls does have breaking changes between the 0.9.1 (required by hdl_checker) and 0.10+ (in nixpkgs)
  # the pygls version is overriden below
  prePatch = ''
    substituteInPlace setup.py --replace "argparse" ""
    substituteInPlace setup.py --replace "typing>=3.7.4" ""
    substituteInPlace setup.py --replace "requests==" "requests>="
  '';

  #  checkInputs =  with python3Packages; [ nose pytestCheckHook mock unittest2 parameterized ghdl coverage  ];
  doCheck =
    false; # testsuite seems to made to only run on CI, depends on Modelsim :((((
  propagatedBuildInputs = with python3Packages; [
    prettytable
    bottle
    requests
    waitress
    pygls
    tabulate
    six
    argcomplete
    future
  ];

}
