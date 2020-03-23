{ lib, pkgs }:

pkgs.buildPythonPackage rec {
  pname = "watchdog-gevent";
  version = "0.1.1";

  src = pkgs.fetchPypi {
    pname = "watchdog_gevent";
    inherit version;
    sha256 = "sha256:0jj2y8jm28vhjdpn1sx1v5a4vkm7aapvlwyws6pxxcsiqigfvp3i";
  };

  propagatedBuildInputs = with pkgs; [
    watchdog gevent
  ];

  doCheck = false;

  meta = {
    description = "A gevent-based observer for watchdog.";
    homepage = https://github.com/Bogdanp/watchdog_gevent;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
