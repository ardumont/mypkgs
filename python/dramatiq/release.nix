{ lib, pkgs, fetchPypi, buildPythonPackage, prometheus-client, watchdog-gevent }:

buildPythonPackage rec {
  pname = "dramatiq";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:1f3yl6pgh089ahw8kk5fmngzxg7zzgbv1hkiv2pbzf9zjrs2ac1n";
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
