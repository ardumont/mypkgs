{ lib, pkgs }:

pkgs.buildPythonPackage rec {
  pname = "xkeysnail";
  version = "0.4.0";

   src = pkgs.fetchPypi {
     inherit pname version;
     sha256 = "1xyqp6yqxcwmxaqj86qcsiz0ly7bwr0a2w835myz909irhip3ngf";
   };

   propagatedBuildInputs = with pkgs; [
     xlib evdev appdirs inotify-simple
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
