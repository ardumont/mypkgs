{ lib, pkgs, buildPythonPackage, fetchPypi, inotify-simple }:

buildPythonPackage rec {
  pname="xkeysnail";
  version = "0.1.0";

   src = fetchPypi {
     inherit pname version;
     sha256 = "4f20afcbebd533ca691f1c3672db6f27caa9a336556abc2a5799676851942062";
   };

   propagatedBuildInputs = [
     pkgs.xlib pkgs.evdev inotify-simple
   ];

   doCheck = false;

   meta = {
     homepage = https://github.com/mooz/xkeysnail;
     description = ''
     xkeysnail is yet another keyboard remapping tool
     for X environment. It’s like xmodmap but allows more flexible
     remappings.
     '';
     license = lib.licenses.gpl3;
     maintainers = with lib.maintainers; [ ardumont ];
  };
}
