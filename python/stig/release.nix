{ lib, pkgs, async_http }:

pkgs.buildPythonPackage rec {
  pname = "stig";
  version = "0.10.1a0";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1xi87kmnyfvdwwx6g6hdgzb6c0jwl98fpvhrg62py80x3j5qlc4a";
  };

  doCheck = false;  # no test (bad me T.T)

  # buildInputs = [ asynctest ];
  propagatedBuildInputs = with pkgs; [
    aiohttp pyxdg blinker natsort setproctitle
    urwid urwidtrees  # need override
    pygeoip  # not sure it's the right one
    GeoIP    # not sure also
    # below are the one not packaged yet (when uncommented, packaged here)
    async_http
    # async_timeout
    # maxminddb
  ];

  meta = {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = https://github.com/rndusr/stig;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
