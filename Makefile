NIXPKGS=$(HOME)/repo/public/nixpkgs

%:
	nix-build -A $@

xkeysnail:
	nix-build -I nixpkgs=$(NIXPKGS) -A $@

stig:
	nix-build -I nixpkgs=$(NIXPKGS) -A $@
