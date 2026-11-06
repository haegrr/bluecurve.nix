{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk2,
  gtk3,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bluecurve";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "neeeeow";
    repo = "Bluecurve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-paOIvENENdUyYgB3SoOjJ2Co1vxEbxbljaLojkOjRh8=";
  };

  patches = [
    ./relative-install-paths.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    (python3.withPackages (
      pkgs: with pkgs; [
        lxml
      ]
    ))
  ];

  buildInputs = [
    gtk2
    gtk3
  ];

  postInstall = ''
    substituteInPlace "$out/share/themes/Bluecurve/gtk-2.0/gtkrc" \
      --replace-fail 'engine "bluecurve"' \
      "engine \"$out/lib/gtk-2.0/2.10.0/engines/libbluecurve.so\""
  '';

  dontCheckForBrokenSymlinks = true;
  dontRewriteSymlinks = true;

  meta = {
    description = "Red Hat Bluecurve theme for GTK 2, 3 and 4";
    homepage = "https://github.com/neeeeow/Bluecurve";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
