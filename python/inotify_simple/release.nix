{ lib, buildPythonPackage, fetchPypi, inotify-tools }:

buildPythonPackage rec {
  pname = "inotify_simple";
  version = "1.1.8";

   src = fetchPypi {
     inherit pname version;
     sha256 = "1pfqvnynwh318cakldhg7535kbs02asjsgv6s0ki12i7fgfi0b7w";
   };

   propagatedBuildInputs = [ inotify-tools ];
   doCheck = false;  # no test

   meta = {
     homepage = https://github.com/chrisjbillington/inotify_simple;
     description = ''
       inotify_simple is a simple Python wrapper around
       inotify. No fancy bells and whistles, just a literal wrapper
       with ctypes. Only 122 lines of code!
     '';
     license = lib.licenses.bsdOriginal;
     maintainers = with lib.maintainers; [ ardumont ];
  };
}
