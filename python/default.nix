with import <nixpkgs> {};

# override pytaglib in python interpreter to inhibit
# the tests as 1 fail (because it missed 1 file in the pypi package)
# issue: https://github.com/supermihi/pytaglib/pull/46
# pr to fix it: https://github.com/supermihi/pytaglib/pull/56
let python-fixed =
  let packageOverrides = self: super: {
      pytaglib = super.pytaglib.overridePythonAttrs(old: rec {
        doCheck = false;
      });
    };
  in pkgs.python3.override {inherit packageOverrides;};
in with python-fixed; (
let
  pyexifinfo = pkgs.buildPythonPackage rec {
    pname="pyexifinfo";
    version = "0.4.0";

     src = pkgs.fetchPypi {
       inherit pname version;
       sha256 = "1jdxskyz2vwsiha8dm7pcg59srzcybwqh9dnwsxpgzlkqnrk92sp";
     };

    propagatedBuildInputs = with pkgs; [
      exiftool
    ];

     # patch setup.py so that the embedded check on exiftool in setup.py passes
     postUnpack = ''
sed -e 's,"exiftool","${exiftool}/bin/exiftool",g' -i pyexifinfo-${version}/setup.py
     '';

     meta = {
       homepage = https://github.com/guinslym/pyexifinfo;
       description = "Yet Another python wrapper for Phil Harvey's Exiftool";
    };
  };

  ardumont-pytools = pkgs.buildPythonPackage rec {
    name = "ardumont-pytools";
    src = /home/tony/repo/private/ardumont-pytools;
    doCheck = false;  # none (bad me T.T)
    propagatedBuildInputs = with pkgs; [
      click vcversioner celery pyinotify exifread pyexifinfo
      python-dateutil tvdb_api tvnamer arrow
      pyaml
      pytaglib
    ];
  };
  in withPackages (ps: [ ardumont-pytools ])
).env