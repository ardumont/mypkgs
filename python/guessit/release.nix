{ lib, pkgs, ... }:

pkgs.buildPythonPackage rec {
  pname = "guessit";
  version = "3.3.1";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "07irn3qsczjaqny9k5282545hv7mk0zk02554244lq99c44f01c3";
  };
}
