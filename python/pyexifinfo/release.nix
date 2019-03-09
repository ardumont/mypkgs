{ lib, pkgs, buildPythonPackage, fetchPypi, exiftool }:

buildPythonPackage rec {
  pname="pyexifinfo";
  version = "0.4.0";

   src = fetchPypi {
     inherit pname version;
     sha256 = "1jdxskyz2vwsiha8dm7pcg59srzcybwqh9dnwsxpgzlkqnrk92sp";
   };

   propagatedBuildInputs = [ exiftool ];

   # patch setup.py so that the embedded check on exiftool in setup.py passes
   postUnpack = ''
     sed -e 's,"exiftool","${exiftool}/bin/exiftool",g' -i pyexifinfo-${version}/setup.py
   '';

   meta = {
     homepage = https://github.com/guinslym/pyexifinfo;
     description = "Yet Another python wrapper for Phil Harvey's Exiftool";
     license = lib.licenses.gpl2;
     maintainers = with lib.maintainers; [ ardumont ];
  };
}
