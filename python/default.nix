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
in
(
let
  pyexifinfo = pkgs.callPackage ./pyexifinfo/release.nix {
    pkgs = pkgs;
    buildPythonPackage = pkgs.python37Packages.buildPythonPackage;
    fetchPypi = pkgs.python37Packages.fetchPypi;
  };

  ardumont-pytools = pkgs.python37Packages.buildPythonPackage rec {
    name = "ardumont-pytools";
    src = /home/tony/repo/private/ardumont-pytools;
    doCheck = false;  # none (bad me T.T)
    propagatedBuildInputs = with python-fixed.pkgs; [
      click vcversioner celery pyinotify exifread pyexifinfo
      python-dateutil tvdb_api tvnamer arrow
      pyaml
      pytaglib
    ];
  };
  in pkgs.python3.withPackages (ps: [ ardumont-pytools ])
).env