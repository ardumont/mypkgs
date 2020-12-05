{ lib, pkgs, pyexifinfo, inotify-tools, mutagen, dramatiq, libav }:

pkgs.buildPythonPackage rec {
  name = "ardumont-pytools";

  src = /home/tony/repo/private/ardumont-pytools;

  doCheck = true;

  checkInputs = with pkgs; [
    pytest pytest-mock pika
  ];

  propagatedBuildInputs = with pkgs; [
    pyexifinfo
    click vcversioner pyinotify exifread python-dateutil
    tvdb_api tvnamer arrow pyaml inotify-tools mutagen
    dramatiq libav setuptools pre-commit
  ];

  meta = {
    description = "Basic python tools";
    homepage = https://gitlab.com/ardumont/ardumont-pytools;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ardumont ];
  };
}
