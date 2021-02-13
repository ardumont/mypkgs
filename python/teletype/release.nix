{ lib, pkgs, ... }:

pkgs.buildPythonPackage rec {
  pname = "teletype";
  version = "1.1.0";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "02mg0qmdf7hljq6jw1hwaid3hvkf70dfxgrxmpqybaxrph5pfg1y";
  };

  doCheck = false;

  meta = {
    description = "A high-level cross platform tty library";
    homepage = https://github.com/jkwill87/teletype;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ardumont ];
  };

}
