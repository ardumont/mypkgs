{ lib, pkgs, buildPythonPackage, fetchPypi, inotify-simple }:

buildPythonPackage rec {
  pname = "xkeysnail";
  version = "0.2.0";

   src = fetchPypi {
     inherit pname version;
     sha256 = "1zssbbd0qb9vpjj2jgw496x08qn08fapl55gm3pcw8bs8yf4kwlx";
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
