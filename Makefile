NIXPKGS=$(HOME)/repo/public/nixpkgs

%:
	nix build #.$@

show-deps:
	niv show
