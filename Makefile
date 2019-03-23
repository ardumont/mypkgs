NIXPKGS=$(HOME)/repo/public/nixpkgs

%:
	nix-build -A $@
