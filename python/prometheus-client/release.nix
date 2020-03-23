{ lib, pkgs }:

pkgs.buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.7.1";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256:1ni2yv4ixwz32nz39ckia76lvggi7m19y5f702w5qczbnfi29kbi";
  };

  doCheck = false;

  meta = {
    description = "The official Python 2 and 3 client for Prometheus.";
    homepage = https://github.com/prometheus/client_python/;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
