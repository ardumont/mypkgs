{ stdenv, fetchgit
, cmake, pkg-config
# required
, libupnp, libuuid, pugixml, libiconv, sqlite, zlib, spdlog, fmt
, pkgs
# options
, enableDuktape ? true
, enableMysql ? false
, enableCurl ? true
, enableTaglib ? true
, enableLibmagic ? true
, enableLibmatroska ? true
, enableAvcodec ? false
, enableLibexif ? true
, enableExiv2 ? false
, enableLiblastfm ? false
, enableFFmpegThumbnailer ? false
, enableInotifyTools ? true
, enableSystemd ? false
}:

with stdenv.lib;
let
  optionOnOff = option: if option then "on" else "off";
in stdenv.mkDerivation rec {
  pname = "gerbera";
  version = "1.5.0";

  src = fetchgit {
    url = meta.repositories.git;
    rev = "0c486fc53b097227db2443c738647690635bdf99";
    sha256 = "sha256:19370aagyqyik5dx3ymr0l4sqgwsa5bv8n25lcdcdg1vm2avq0y1";
  };

  # hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DWITH_JS=${optionOnOff enableDuktape}"
    "-DWITH_MYSQL=${optionOnOff enableMysql}"
    "-DWITH_CURL=${optionOnOff enableCurl}"
    "-DWITH_TAGLIB=${optionOnOff enableTaglib}"
    "-DWITH_MAGIC=${optionOnOff enableLibmagic}"
    "-DWITH_MATROSKA=${optionOnOff enableLibmatroska}"
    "-DWITH_AVCODEC=${optionOnOff enableAvcodec}"
    "-DWITH_EXIF=${optionOnOff enableLibexif}"
    "-DWITH_EXIV2=${optionOnOff enableExiv2}"
    "-DWITH_LASTFM=${optionOnOff enableLiblastfm}"
    "-DWITH_FFMPEGTHUMBNAILER=${optionOnOff enableFFmpegThumbnailer}"
    "-DWITH_INOTIFY=${optionOnOff enableInotifyTools}"
    "-DWITH_SYSTEMD=${optionOnOff enableSystemd}"
  ];

  # dontUseCmakeBuildDir = true;
  # dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake pkg-config ];

  # dontFixCmake = true;
  # storepath = placeholder "out";

  buildInputs = [
    libupnp libuuid pugixml libiconv sqlite zlib fmt.dev
    spdlog
  ]
  ++ optionals enableSystemd [ pkgs.systemd ]
  ++ optionals enableMysql [ pkgs.libmysqlclient ]
  ++ optionals enableDuktape [ pkgs.duktape ]
  ++ optionals enableCurl [ pkgs.curl ]
  ++ optionals enableTaglib [ pkgs.taglib ]
  ++ optionals enableLibmagic [ pkgs.file ]
  ++ optionals enableLibmatroska [ pkgs.libmatroska pkgs.libebml ]
  ++ optionals enableAvcodec [ pkgs.libav.dev ]
  ++ optionals enableLibexif [ pkgs.libexif ]
  ++ optionals enableExiv2 [ pkgs.exiv2 ]
  ++ optionals enableLiblastfm [ pkgs.liblastfm ]
  ++ optionals enableInotifyTools [ pkgs.inotify-tools ]
  ++ optionals enableFFmpegThumbnailer [ pkgs.ffmpegthumbnailer ];


  meta = with stdenv.lib; {
    homepage = http://mediatomb.cc;
    repositories.git = https://github.com/gerbera/gerbera;
    description = "UPnP Media Server for 2020";
    longDescription = ''
Stream your digital media through your home network and consume it on all kinds
of UPnP supporting devices.
'';
    license = licenses.gpl2;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
