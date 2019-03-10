{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackagesWith (pkgs // self);
  # override pytaglib in python interpreter to inhibit
  # the tests as 1 fail (because it missed 1 file in the pypi package)
  # issue: https://github.com/supermihi/pytaglib/pull/46
  # pr to fix it: https://github.com/supermihi/pytaglib/pull/56
  self = rec {
    # if this is used a dependency for another haskellPackage you
    # will need to redefine "pkgs.haskellPackages.callPackage",
    # but for simple cases this is sufficient.
    # jot = pkgs.haskellPackages.callPackage /home/amy/jot/jot.nix { };
    # foo = callPackage /path/to/foo { }; # where directory foo contains a default.nix
    # harold = callPackage /path/to/harold/harold.nix { };
    pyexifinfo = pkgs.callPackage ./python/pyexifinfo/release.nix {
      buildPythonPackage = pkgs.python36Packages.buildPythonPackage;
      fetchPypi = pkgs.python36Packages.fetchPypi;
    };
    ardumont-pytools = pkgs.callPackage ./python/ardumont-pytools/release.nix {
      pkgs = pkgs.python36Packages;
      buildPythonPackage = pkgs.python36Packages.buildPythonPackage;
      pyexifinfo = pyexifinfo;
      inotify-tools = pkgs.inotify-tools;
    };
  };
in self
