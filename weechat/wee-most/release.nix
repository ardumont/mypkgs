{ lib, stdenv, substituteAll, buildEnv, fetchgit, python3Packages, ... }:

let wee-most-env = buildEnv {
      name = "wee-most-env";
      paths = with python3Packages; [
        websocket-client
        six
      ];
    };
in stdenv.mkDerivation rec {
  pname = "wee-most";
  version = "0.3.0";

  src = fetchgit {
    url = "https://git.sr.ht/~tardypad/wee-most";
    rev = "v${version}";
    # rev = "28caa0b01cd7700334186f53256d1ac145ea549a";
    # rev = "master";
    sha256 = "1r1sxz81naq8cw5gmyx12kr46s1pjdzhnnmzda8fr29infphb6vx";
  };

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  # patches = [
  #   ./wee-most-env-path.patch
  # ];

  # postPatch = ''
  #   substituteInPlace wee_most.py \
  #     --replace "@env@" "${wee-most-env}/${python3Packages.python.sitePackages}"
  # '';

  patches = [
    (substituteAll {
      src = ./wee-most-env-path.patch;
      # env = "foo";
      env = "${wee-most-env}/${python3Packages.python.sitePackages}";
    })
  ];

  passthru.scripts = [ "wee_most.py" ];

  installPhase = ''
    mkdir -p $out/share
    install -D -m 0644 wee_most.py $out/share/wee_most.py
    install -D -m 0644 wee_most_emojis $out/share/wee_most_emojis
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~tardypad/wee-most";
    description = "WeeChat script for Mattermost";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ardumont ];
  };
}
