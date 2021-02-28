NIXPKGS=$(HOME)/repo/public/nixpkgs

%:
	nix build .#packages.x86_64-linux.$@

show-deps:
	niv show
