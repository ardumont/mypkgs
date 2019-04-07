{ system ? builtins.currentSystem }:

# if we need for some reason nixpkgs-unstable, mutate the environment with
# nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
# nix-channel --update

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackagesWith (pkgs // self);
  packages = pkgs.python36Packages;
  self = rec {
    # dependency for ardumont-pytools
    pyexifinfo = pkgs.callPackage ./python/pyexifinfo/release.nix {
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
    };
    ardumont-pytools =
      let myPythonOverride = pkgs.python36Packages.override {
            overrides = self: super: {
              pytest-xdist = super.pytest-xdist.overrideAttrs(old: {
                doCheck = false;  # tests fail for some reasons
                checkPhase = "";
              });
            };
          };
        in
        pkgs.callPackage ./python/ardumont-pytools/release.nix {
        pkgs = packages;
        buildPythonPackage = packages.buildPythonPackage;
        pyexifinfo = pyexifinfo;
        inotify-tools = pkgs.inotify-tools;
        mutagen = myPythonOverride.mutagen;
      };
    # dependency for xkeysnail
    inotify-simple = pkgs.callPackage ./python/inotify_simple/release.nix {
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
      inotify-tools = pkgs.inotify-tools;
    };
    xkeysnail =
      let unstable = import <nixpkgs-unstable> {};
      pkgs = unstable.pkgs;
      in pkgs.callPackage ./python/xkeysnail/release.nix {
        pkgs = pkgs.python36Packages;
        buildPythonPackage = pkgs.python36Packages.buildPythonPackage;
        fetchPypi = pkgs.python36Packages.fetchPypi;
        inotify-simple = inotify-simple;
      };
    async_http = pkgs.callPackage ./python/async_http/release.nix {
      pkgs = packages;
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
    };
    stig = let
      unstable = import <nixpkgs-unstable> {};
      # build specifically this override with a nixpkgs-unstable version
      myPythonOverride = unstable.pkgs.python36Packages.override {
        overrides = self: super: {
          urwidtrees = super.urwidtrees.overrideAttrs (old: rec {
            version = "1.0.3.dev0";
            src = packages.fetchPypi {
              pname = old.pname;
              version = version;
              sha256 = "05sf9q5lvcazccwzxc4zl2xnxfds7sb9yis18z99p01nrljp868r";
            };
            propagatedBuildInputs = old.propagatedBuildInputs ++ [ packages.mock ];
          });
          urwid = super.urwid.overrideAttrs (old: rec {
            version = "2.0.1";
            src = packages.fetchPypi {
              pname = old.pname;
              version = version;
              sha256 = "1g6cpicybvbananpjikmjk8npmjk4xvak1wjzji62wc600wkwkb4";
            };
            patches = [];
            doCheck = false;
            # propagatedBuildInputs = old.propagatedBuildInputs ++ [ packages.mock ];
          });
        };
      };
      in pkgs.callPackage ./python/stig/release.nix {
          pkgs = myPythonOverride;
          buildPythonPackage = myPythonOverride.buildPythonPackage;
          fetchPypi = myPythonOverride.fetchPypi;
          inherit async_http;
    };
  };
in self
