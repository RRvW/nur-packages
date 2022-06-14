{ lib, buildPythonPackage, fetchPypi, dill, six, pytestCheckHook, typing
, pythonAtLeast }:

buildPythonPackage rec {
  pname = "pydecor";
  version = "2.0.1";

  disabled = !(pythonAtLeast "3.6"); # requires python version >=3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6cec380951b60a90c4c465befe6d0b8ef4e71fb7819b7cca40e326a988176d4";
  };

  # # Package conditions to handle
  # # might have to sed setup.py and egg.info in patchPhase
  # # sed -i "s/<package>.../<package>/"
  # typing ; python_version < "3.5"
  # # Extra packages (may not be necessary)
  # coverage ; extra == 'dev'
  # pytest (>=4.6) ; extra == 'dev'
  # tox ; extra == 'dev'
  # wheel ; extra == 'dev'
  # flake8 ; (implementation_name == "cpython") and extra == 'dev'
  # ipdb ; (implementation_name == "cpython") and extra == 'dev'
  # mypy ; (implementation_name == "cpython") and extra == 'dev'
  # pylint ; (implementation_name == "cpython") and extra == 'dev'
  # pytest-cov ; (implementation_name == "cpython") and extra == 'dev'
  # pytest-cov (==2.8.1) ; (implementation_name == "pypy") and extra == 'dev'
  # mock ; (python_version < "3.0") and extra == 'dev'
  # pytest-cov (==2.8.1) ; (python_version <= "3.7") and extra == 'dev'
  # black ; (python_version > "3.5" and implementation_name == "cpython") and extra == 'dev'
  propagatedBuildInputs = [ dill six typing ];
  checkInputs = [ pytestCheckHook ];
  doCheck = true;
  meta = with lib; {
    description = "Easy peasy Python decorators";
    homepage = "https://github.com/mplanchard/pydecor";
    license = licenses.mit;
    # maintainers = [ maintainers. ];
  };
}
