{ pkgs, lib, ... }:

let python-packages = pkgs.python3Packages;
in rec {
  fmt = pkgs.fmt;

  spdlog = pkgs.spdlog.overrideAttrs (oldAttrs: rec {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DSPDLOG_FMT_EXTERNAL=ON"
    ];

    buildInputs = [
      pkgs.fmt.dev
      pkgs.pkg-config pkgs.systemd
    ];
  });  # ok

  teletype = pkgs.callPackage ./python/teletype/release.nix {
    inherit lib;
    pkgs = python-packages;
  };

  requests-cache = pkgs.callPackage ./python/requests-cache/release.nix {
    inherit lib;
    pkgs = python-packages;
  };

  mnamer = pkgs.callPackage ./python/mnamer/release.nix {
    inherit lib teletype requests-cache;
    pkgs = python-packages;
  };

  emacs-powerline = pkgs.callPackage ./emacs/emacs-powerline/release.nix { };
  watchdog-gevent = pkgs.callPackage ./python/watchdog-gevent/release.nix {
    pkgs = python-packages;
  };
  xkeysnail = pkgs.callPackage ./python/xkeysnail/release.nix {
    pkgs = python-packages;
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

  wee-most = pkgs.callPackage ./weechat/wee-most/release.nix { };
}
