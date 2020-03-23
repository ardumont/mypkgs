{ lib, pkgs }:

pkgs.buildPythonPackage rec {
  pname = "async_http";
  version = "0.12";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "09b8bnhkyi0j1w5qyqvbksm098w39fy7wqfc5dmcbpipybdfpmgd";
  };

  doCheck = false;

  meta = {
    description = "A http client package that plugs in with the standard asyncore/asynchat modules";
    homepage = https://github.com/josiahcarlson/async_http;
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
