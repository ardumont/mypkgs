{ stdenv, fetchFromGitHub, emacs }:

stdenv.mkDerivation rec {
  version = "0.62";  # well more advanced than last release
  name = "emacs-anzu-${version}";

  src = fetchFromGitHub {
    owner  = "emacsorphanage";
    repo   = "anzu";
    rev    = "61cb32aa61f9bd088c519ea3cc96b81e241efed7";
    sha256 = "sha256:1b2zjich6mvypycsrz5jkpv5mbaj77jka17vcc5ss2390dad92f8";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta.license = stdenv.lib.licenses.gpl3Plus;
}
