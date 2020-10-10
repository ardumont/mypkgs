{ lib, pkgs, prometheus-client }:

pkgs.buildPythonPackage rec {
  pname = "dramatiq";
  version = "1.9.0";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0f9qhxn2b95b1sbdaggy033b3cgrj6lkgldciclg197dn8d984l1";
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
