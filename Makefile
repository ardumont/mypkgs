NIXPKGS=$(HOME)/repo/public/nixpkgs

%:
	nix build -f default.nix $@

show-deps:
	niv show

add-stable:
	niv modify nixpkgs -a branch=nixpkgs-19.09
