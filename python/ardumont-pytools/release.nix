{ lib, pkgs, buildPythonPackage, pyexifinfo }:

buildPythonPackage rec {
  name = "ardumont-pytools";

  src = /home/tony/repo/private/ardumont-pytools;

  doCheck = false;  # no test (bad me T.T)

  propagatedBuildInputs = with pkgs; [
    pyexifinfo
    click vcversioner celery pyinotify exifread python-dateutil
    tvdb_api tvnamer arrow pyaml
  ];

  meta = {
    description = "Basic python tools";
    homepage = https://gitlab.com/ardumont/ardumont-pytools;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
