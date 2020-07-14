{ system ? builtins.currentSystem, sources ? import ./nix/sources.nix, ... }:

let
  pkgs = import sources.nixpkgs { inherit system; };
  pkgs-unstable = import sources.nixpkgs-unstable { inherit system; };
  python-packages = pkgs.python3Packages;
  self = rec {
    fmt = pkgs-unstable.fmt;

    spdlog = pkgs-unstable.spdlog.overrideAttrs (oldAttrs: rec {
      cmakeFlags = oldAttrs.cmakeFlags ++ [
        "-DSPDLOG_FMT_EXTERNAL=ON"
      ];

      buildInputs = [
        pkgs-unstable.fmt.dev
        pkgs.pkg-config pkgs.systemd
      ];
    });  # ok

    libupnp12 = pkgs-unstable.libupnp.overrideAttrs (oldAttrs: rec {
      version = "1.12.1";
      src = pkgs.fetchFromGitHub {
        owner = "mrjimenez";
        repo = "pupnp";
        rev = "release-${version}";
        sha256 = "sha256:0h7qfkin2l9riwskqn9zkn1l8z2gqfnanvaszjyxga2m5axz4n8c";
      };
      configureFlags = "--enable-reuseaddr";
    });

    gerbera = let libupnp = libupnp12;
      in pkgs.callPackage ./media/gerbera/release.nix { inherit libupnp fmt spdlog; };

    gerberaFull = let libupnp = libupnp12;
      in pkgs.callPackage ./media/gerbera/release.nix {
        inherit libupnp fmt spdlog;
        enableAvcodec = true;
        enableFFmpegThumbnailer = true;
      };

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
      inherit pyexifinfo dramatiq;
      inotify-tools = pkgs.inotify-tools;
      mutagen = python-packages.mutagen;
      libav = pkgs.libav;
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
