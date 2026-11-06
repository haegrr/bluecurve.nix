{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  qt5,
  qt6,
  qtVersion ? 5,
}:
let
  qt =
    if qtVersion == 5 then
      qt5
    else if qtVersion == 6 then
      qt6
    else
      throw "invalid qtVersion ${toString qtVersion}";
in
stdenv.mkDerivation {
  pname = "bluecurve-qt${toString qtVersion}";
  version = "0-unstable-2026-10-15";

  src = fetchFromGitHub {
    owner = "neeeeow";
    repo = "Bluecurve-Qt";
    rev = "e9b3801c200979c9bc9e813178e9ef983a48e037";
    hash = "sha256-PlT8p8/XMJpTrDoTcPf/htD1+dCNRic62WllwRaN02Q=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    qt.qtbase
  ];

  cmakeFlags = [
    "-DBUILD_QT5=OFF"
    "-DBUILD_QT6=OFF"
    "-DBUILD_QT${toString qtVersion}=ON"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Bluecurve theme ported to Qt ${toString qtVersion}";
    homepage = "https://github.com/neeeeow/Bluecurve-Qt";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
