{ lib, buildPythonPackage, fetchpatch, fetchPypi, pythonOlder, typing-extensions
, cython, cmake, python3Packages }:

buildPythonPackage rec {
  pname = "networkit";
  version = "10.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b+adsReLaTBcQINpU7b3cxV04hHOpTztUrvEW5//Kh0=";
  };

  nativeBuildInputs = [ cmake cython ];

  propagatedBuildInputs =
    lib.optionals (pythonOlder "3.10") [ typing-extensions ]
    ++ (with python3Packages; [ scipy ]);

  preBuildPhases = "postConfigurePhase preBuildPhase";
  postConfigurePhase = "cd $cmakeDir && echo POSTCONFIGURE: $PWD";

  # setup.py doesn't like the --parallel flag,
  # but it does support parallelism via this env var.
  enableParallelBuilding = false;
  preBuildPhase = "export NETWORKIT_PARALLEL_JOBS=$NIX_BUILD_CORES";

  checkInputs = with python3Packages; [ nose ];
  # there's a test that tries to write a file to this directory,
  # and fails if it doesn't exist.
  preCheck = "mkdir -p output";

  meta = with lib; {
    description =
      "NetworKit is a growing open-source toolkit for large-scale network analysis. ";
    license = licenses.mit;
    homepage = "https://networkit.github.io/";
    maintainers = with maintainers; [ teh ];
  };
}
