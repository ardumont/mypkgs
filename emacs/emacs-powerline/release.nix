{ stdenv, fetchFromGitHub, emacs, lib, ... }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "emacs-powerline-${version}";

  src = fetchFromGitHub {
    owner  = "jonathanchu";
    repo   = "emacs-powerline";
    rev    = "bbbbcd70641249f9dc9d3ea37997d6c60efdaf9b";
    sha256 = "0fnfn4v462j4y3d81hisrnfl1i25ky8wmgg3p4lvlzraaipqrdb5";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta.license = lib.licenses.gpl3Plus;
}
