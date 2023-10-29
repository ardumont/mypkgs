{ lib, stdenv, substituteAll, buildEnv, fetchgit, python3Packages, ... }:

let wee-matter-env = buildEnv {
      name = "wee-matter-env";
      paths = with python3Packages; [
        websocket-client
        six
      ];
    };
in stdenv.mkDerivation rec {
  pname = "wee-matter";
  version = "0.0.1";

  src = fetchgit {
    url = "https://git.sr.ht/~stacyharper/wee-matter";
    rev = "101901d0fd407b690cbcc06dfa2b3d08cdddc6ff";
    # rev = "main";
    sha256 = "0d76ys9z705dr0f0qy0znv92p4gm1mycyf53xh5p91hqcvp6iy3n";
  };

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  patches = [
    (substituteAll {
      src = ./wee-matter-env.patch;
      env = "${wee-matter-env}/${python3Packages.python.sitePackages}";
    })
  ];

  passthru.scripts = [ "wee_matter.py" ];

  installPhase = ''
    mkdir -p $out/share/wee_matter/
    substituteInPlace main.py \
      --replace "__WEE_MATTER_DIRPATH__" "$out/share/wee_matter/"
    install -D -m 644 main.py $out/share/wee_matter.py
    install -D -m 644 wee_matter/* $out/share/wee_matter/
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~stacyharper/wee-matter";
    description = "Wee-Matter is a Mattermost backend to Weechat.";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ardumont ];
  };
}
