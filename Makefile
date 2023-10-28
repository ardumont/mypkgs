NIXPKGS=$(HOME)/repo/public/nixpkgs

%:
	nix build --verbose .#packages.x86_64-linux.$@

info:
	nix flake info

details:
	nix flake show
