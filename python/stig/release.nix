{ lib, pkgs, fetchPypi, buildPythonPackage, async_http }:

buildPythonPackage rec {
  pname = "stig";
  version = "0.10.1a0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xi87kmnyfvdwwx6g6hdgzb6c0jwl98fpvhrg62py80x3j5qlc4a";
  };

  doCheck = false;  # no test (bad me T.T)

  propagatedBuildInputs = with pkgs; [
    urwid aiohttp pyxdg blinker natsort setproctitle
    urwidtrees  # need override
    # pygeoip  # not sure it's the right one
    GeoIP    # not sure also
    async_http  # apparently not packaged yet
  ];

  meta = {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = https://github.com/rndusr/stig;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
