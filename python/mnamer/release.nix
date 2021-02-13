{ pkgs, lib, teletype, requests-cache, ... }:

pkgs.buildPythonPackage rec {
  pname = "mnamer";
  version = "2.5.2";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "00msrxzxkm9ym93f5gdxrwpmcjs9lm7zhgdymg40qgfrb7zsazgq";
  };

  patches = [
    ./requirements-no-pinning.patch
  ];

  propagatedBuildInputs = with pkgs; [
    guessit
    appdirs
    babelfish
    requests
    # to define
    requests-cache
    teletype
  ];

  doCheck = false;

  meta = {
    description = "A fast and reliable distributed task processing library for Python 3.";
    homepage = https://github.com/Bogdanp/dramatiq;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
