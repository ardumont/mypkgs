NIXPKGS=$(HOME)/repo/public/nixpkgs

%:
	nix build -f default.nix $@

show-deps:
	niv show
