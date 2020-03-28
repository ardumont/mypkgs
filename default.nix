{ system ? builtins.currentSystem, sources ? import ./nix/sources.nix }:

let
  pkgs = import sources.nixpkgs { inherit system; };
  python-packages = pkgs.python3Packages;
  self = rec {
    emacs-powerline = pkgs.callPackage ./emacs/emacs-powerline/release.nix { };
    # dependency for ardumont-pytools
    pyexifinfo = pkgs.callPackage ./python/pyexifinfo/release.nix {
      pkgs = python-packages;
    };
    prometheus-client = pkgs.callPackage ./python/prometheus-client/release.nix {
      pkgs = python-packages;
    };
    watchdog-gevent = pkgs.callPackage ./python/watchdog-gevent/release.nix {
      pkgs = python-packages;
    };
    dramatiq = pkgs.callPackage ./python/dramatiq/release.nix {
      pkgs = python-packages;
      inherit prometheus-client watchdog-gevent;
    };
    ardumont-pytools = pkgs.callPackage ./python/ardumont-pytools/release.nix {
      pkgs = python-packages;
      pyexifinfo = pyexifinfo;
      inotify-tools = pkgs.inotify-tools;
      mutagen = python-packages.mutagen;
      dramatiq = dramatiq;
    };
    # dependency for xkeysnail
    inotify-simple = pkgs.callPackage ./python/inotify_simple/release.nix {
      pkgs = python-packages;
    };
    xkeysnail = pkgs.callPackage ./python/xkeysnail/release.nix {
      pkgs = python-packages;
      inotify-simple = inotify-simple;
    };
    async_http = pkgs.callPackage ./python/async_http/release.nix {
      pkgs = python-packages;
    };
    stig = let
      my-python-override = python-packages.override {
        overrides = self: super: {
          urwidtrees = super.urwidtrees.overrideAttrs (old: rec {
            version = "1.0.3.dev0";
            src = python-packages.fetchPypi {
              pname = old.pname;
              version = version;
              sha256 = "05sf9q5lvcazccwzxc4zl2xnxfds7sb9yis18z99p01nrljp868r";
            };
            propagatedBuildInputs = old.propagatedBuildInputs ++ [ python-packages.mock ];
          });
          urwid = super.urwid.overrideAttrs (old: rec {
            version = "2.0.1";
            src = python-packages.fetchPypi {
              pname = old.pname;
              version = version;
              sha256 = "1g6cpicybvbananpjikmjk8npmjk4xvak1wjzji62wc600wkwkb4";
            };
            patches = [];
            doCheck = false;
            # propagatedBuildInputs = old.propagatedBuildInputs ++ [ python-packages.mock ];
          });
        };
      };
    in pkgs.callPackage ./python/stig/release.nix {
      pkgs = my-python-override;
      inherit async_http;
    };
  };
in self
