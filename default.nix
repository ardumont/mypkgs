{ system ? builtins.currentSystem, sources ? import ./nix/sources.nix }:

let
  pkgs = import sources.nixpkgs { inherit system; };
  callPackage = pkgs.lib.callPackagesWith (pkgs // self);
  my-python-override = pkgs.python3Packages.override {
    overrides = self: super: {
      cherrypy = super.cherrypy.overrideAttrs (old: rec {
        doCheck = false;  # this fails to pass its tests
        checkPhase = "";
      });
    };
  };
  # packages = pkgs.python3Packages;
  packages = my-python-override;
  self = rec {
    emacs-powerline = pkgs.callPackage ./emacs/emacs-powerline/release.nix { };
    # dependency for ardumont-pytools
    pyexifinfo = pkgs.callPackage ./python/pyexifinfo/release.nix {
      buildPythonPackage = packages.buildPythonPackage;
      fetchPypi = packages.fetchPypi;
    };
    prometheus-client = pkgs.callPackage ./python/prometheus-client/release.nix {
      pkgs = packages;
      fetchPypi = packages.fetchPypi;
      buildPythonPackage = packages.buildPythonPackage;
    };
    watchdog-gevent = pkgs.callPackage ./python/watchdog-gevent/release.nix {
      pkgs = packages;
      fetchPypi = packages.fetchPypi;
      buildPythonPackage = packages.buildPythonPackage;
    };
    dramatiq = pkgs.callPackage ./python/dramatiq/release.nix {
      pkgs = packages;
      fetchPypi = packages.fetchPypi;
      buildPythonPackage = packages.buildPythonPackage;
      inherit prometheus-client watchdog-gevent;
    };
    ardumont-pytools = pkgs.callPackage ./python/ardumont-pytools/release.nix {
      pkgs = packages;
      buildPythonPackage = packages.buildPythonPackage;
      pyexifinfo = pyexifinfo;
      inotify-tools = pkgs.inotify-tools;
      mutagen = packages.mutagen;
      dramatiq = dramatiq;
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
    stig = let
      my-python-override = packages.override {
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
      pkgs = my-python-override;
      buildPythonPackage = my-python-override.buildPythonPackage;
      fetchPypi = my-python-override.fetchPypi;
      inherit async_http;
    };
  };
in self
