{
  description = "Mypkgs flake";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-20.03";
    };
  };

  outputs = { self, nixpkgs, ... }:
    with nixpkgs.lib;
    let supportedSystems = [
          "x86_64-linux"
          "i686-linux"
          "aarch64-linux"
        ];
        forEachSystem = f: genAttrs supportedSystems (system: f system);
        pkgsBySystem = forEachSystem (system:
          import nixpkgs {
            inherit system;
            # overlays = self.internal.overlays."${system}";
          }
        );
    in {
      # internals = {
      #   overlays = forEachSystem (system: [
      #     (self.overlay."${system}")
      #     # Add other overlays if any
      #     # ...
      #   ]);
      # };

      # overlay = forEachSystem (system: _: _: self.packages."${system}");

      packages = forEachSystem (system:
        let pkgs = pkgsBySystem."${system}";
            all-pkgs = (import ./default.nix { inherit pkgs; });
        in {
          emacs-powerline = all-pkgs.emacs-powerline;
          fmt = all-pkgs.fmt;
          spdlog = all-pkgs.spdlog;
          watchdog-gevent = all-pkgs.watchdog-gevent;
          inotify-simple = all-pkgs.inotify-simple;
          xkeysnail = all-pkgs.xkeysnail;
          async_http = all-pkgs.async_http;
          stig = all-pkgs.stig;
        }
      );

      defaultPackage = forEachSystem (system: self.packages."${system}".emacs-powerline);
    };
}
