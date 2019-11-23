{ lib, pkgs, fetchPypi, buildPythonPackage, prometheus-client, watchdog-gevent }:

buildPythonPackage rec {
  pname = "dramatiq";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:0ccbynrb6hsfh423jmc4bf0lb582y2rkfqhjci35q9xa5fsj2jvd";
  };

  propagatedBuildInputs = with pkgs; [
    prometheus-client redis watchdog
  ];

  doCheck = false;

  meta = {
    description = "A fast and reliable distributed task processing library for Python 3.";
    homepage = https://github.com/Bogdanp/dramatiq;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
