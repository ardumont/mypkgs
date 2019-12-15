{ lib, pkgs, buildPythonPackage, pyexifinfo, inotify-tools, mutagen, dramatiq }:

buildPythonPackage rec {
  name = "ardumont-pytools";

  src = /home/tony/repo/private/ardumont-pytools;

  doCheck = true;

  propagatedBuildInputs = with pkgs; [
    pyexifinfo
    click vcversioner pyinotify exifread python-dateutil
    tvdb_api tvnamer arrow pyaml inotify-tools mutagen
    dramatiq pika
  ];

  checkInputs = with pkgs; [
    pytest
  ];

  meta = {
    description = "Basic python tools";
    homepage = https://gitlab.com/ardumont/ardumont-pytools;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
