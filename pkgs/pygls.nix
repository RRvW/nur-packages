{ lib
, python3
, fetchFromGitHub
, setuptools-scm
, lsprotocol
, toml
, typeguard
, mock
, pytest-asyncio
, pytestCheckHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pygls";
  version = "0.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = "pygls";
    rev = "v${version}";
    hash = "sha256-uoHqHp56OoMtulnXyO3PwgBviqoSXw2UR0+ahlIp/ew=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = [
    lsprotocol
    typeguard
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pygls" ];

  meta = with lib; {
    description = "A pythonic generic language server";
    homepage = "https://github.com/openlawlibrary/pygls";
    changelog = "https://github.com/openlawlibrary/pygls/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
