{ lib, pkgs, ... }:

pkgs.buildPythonPackage rec {
  pname = "requests-cache";
  version = "0.5.2";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1svhfamv6fh9m54jh7nx5nr5mbp9wz0rqa720675y146jqk26c41";
  };

  buildInputs = with pkgs; [ requests ];

  meta = {
    description = "Persistent cache for requests library";
    homepage = https://github.com/reclosedev/requests-cache;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ardumont ];
  };

}
