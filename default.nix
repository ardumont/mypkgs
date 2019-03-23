{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackagesWith (pkgs // self);
  # override pytaglib in python interpreter to inhibit
  # the tests as 1 fail (because it missed 1 file in the pypi package)
  # issue: https://github.com/supermihi/pytaglib/pull/46
  # pr to fix it: https://github.com/supermihi/pytaglib/pull/56
  self = let packages = pkgs.python36Packages;
  in rec {
    # if this is used a dependency for another haskellPackage you
    # will need to redefine "pkgs.haskellPackages.callPackage",
    # but for simple cases this is sufficient.
    # jot = pkgs.haskellPackages.callPackage /home/amy/jot/jot.nix { };
    # foo = callPackage /path/to/foo { }; # where directory foo contains a default.nix
    # harold = callPackage /path/to/harold/harold.nix { };
    # dependency for ardumont-pytools
    pyexifinfo = pkgs.callPackage ./python/pyexifinfo/release.nix {
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
    };
    ardumont-pytools = pkgs.callPackage ./python/ardumont-pytools/release.nix {
      pkgs = packages;
      buildPythonPackage = packages.buildPythonPackage;
      pyexifinfo = pyexifinfo;
      inotify-tools = pkgs.inotify-tools;
    };
    # dependency for xkeysnail
    inotify-simple = pkgs.callPackage ./python/inotify_simple/release.nix {
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
      inotify-tools = pkgs.inotify-tools;
    };
    xkeysnail = pkgs.callPackage ./python/xkeysnail/release.nix {
      pkgs = packages;
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
      inotify-simple = inotify-simple;
    };
    async_http = pkgs.callPackage ./python/async_http/release.nix {
      pkgs = packages;
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
    };
  };
in self
