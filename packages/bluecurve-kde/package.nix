{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  qt6,
  gtk3,
  bluecurve,
  bluecurve-qt6,
}:
let
  lookAndFeel = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./metadata.json
      ./contents
    ];
  };
in
stdenv.mkDerivation {
  pname = "bluecurve-kde";
  version = "0-unstable-2026-10-28";

  src = fetchFromGitHub {
    owner = "neeeeow";
    repo = "Bluecurve-KDE";
    rev = "e328ddee85a328a670ff40b4b8fdece453988d98";
    hash = "sha256-rJH9hyZvkuxEuS6Q+tKQjaU+FwW5JPF+28lfgjRBCKc=";
  };

  patches = [
    ./relative-install-paths.patch
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    gtk3
    kdePackages.kcoreaddons
    kdePackages.kdecoration
  ];

  propagatedUserEnvPkgs = [
    bluecurve
    bluecurve-qt6
  ];

  postInstall = ''
    themeDir="$out/share/themes/Bluecurve-KDE"

    for link in "$themeDir"/gtk-{3,4}.0/*; do
      [ -L "$link" ] || continue

      target="$(readlink "$link")"
      case "$target" in
        ../../Bluecurve/*)
          rm "$link"
          ln -s "${bluecurve}/share/themes/''${target#../../}" "$link"
          ;;
      esac
    done

    lafDir="$out/share/plasma/look-and-feel/com.github.haegrr.bluecurve.desktop"
    install -Dm444 "${lookAndFeel}/metadata.json" "$lafDir/metadata.json"
    install -Dm444 "${lookAndFeel}/contents/defaults" "$lafDir/contents/defaults"
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Bluecurve theme ported to KDE 6";
    homepage = "https://github.com/neeeeow/Bluecurve-KDE";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
