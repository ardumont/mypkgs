{ lib, pkgs }:

pkgs.buildPythonPackage rec {
  pname = "appdirs";
  version = "1.4.4";

   src = pkgs.fetchPypi {
     inherit pname version;
     sha256 = "0hfzmwknxqhg20aj83fx80vna74xfimg8sk18wb85fmin9kh2pbx";
   };

   meta = {
     homepage = http://github.com/ActiveState/appdirs;
     description = ''
       A small Python module for determining appropriate
       platform-specific dirs, e.g. a "user data dir".
     '';
     license = lib.licenses.bsdOriginal;
     maintainers = with lib.maintainers; [ ardumont ];
  };
}
