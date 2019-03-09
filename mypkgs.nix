{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackagesWith (pkgs // self);
  # override pytaglib in python interpreter to inhibit
  # the tests as 1 fail (because it missed 1 file in the pypi package)
  # issue: https://github.com/supermihi/pytaglib/pull/46
  # pr to fix it: https://github.com/supermihi/pytaglib/pull/56
  python-fixed =
    let packageOverrides = self: super: {
      pytaglib = super.pytaglib.overridePythonAttrs(old: {
        doCheck = false;
      });
    };
   in pkgs.python3.override {inherit packageOverrides;};
   self = rec {
      # if this is used a dependency for another haskellPackage you
      # will need to redefine "pkgs.haskellPackages.callPackage",
      # but for simple cases this is sufficient.
      # jot = pkgs.haskellPackages.callPackage /home/amy/jot/jot.nix { };
      # foo = callPackage /path/to/foo { }; # where directory foo contains a default.nix
      # harold = callPackage /path/to/harold/harold.nix { };
      pyexifinfo = pkgs.callPackage ./python/pyexifinfo/release.nix {
        buildPythonPackage = pkgs.python37Packages.buildPythonPackage;
        fetchPypi = pkgs.python37Packages.fetchPypi;
      };
      ardumont-pytools = pkgs.callPackage ./python/ardumont-pytools/release.nix {
        pkgs = python-fixed.pkgs;
        buildPythonPackage = pkgs.python37Packages.buildPythonPackage;
        pyexifinfo = pyexifinfo;
      };
  };
in self
