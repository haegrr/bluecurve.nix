{ flakeLib, mkFlakePackages, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.bluecurve;
  flakePackages = mkFlakePackages pkgs;
  anyDesktopText = "config.bluecurve.kde.enable || config.bluecurve.mate.enable || config.bluecurve.xfce.enable";
in
{
  options.bluecurve = {
    enable = lib.mkEnableOption "Bluecurve's GTK, font, and Qt integration" // {
      description = ''
        Whether to enable Bluecurve's GTK, font, and Qt integration by default.
        Desktop integrations (KDE, MATE, and Xfce) remain opt-in.
      '';
    };

    gtk = {
      enable = lib.mkEnableOption "Bluecurve GTK themes, icons, and cursors" // {
        defaultText = lib.literalExpression "config.bluecurve.enable || ${anyDesktopText}";
        description = ''
          Whether to enable Bluecurve GTK themes, icons, and cursors.
          Enabled by default when `bluecurve.enable` or any of the KDE, MATE,
          or Xfce integrations is enabled.
        '';
      };
      package = lib.mkPackageOption flakePackages "bluecurve" {
        pkgsText = "bluecurve.packages.\${pkgs.stdenv.hostPlatform.system}";
      };
    };

    fonts = {
      enable = lib.mkEnableOption "Bluecurve's Luxi fonts" // {
        defaultText = lib.literalExpression "config.bluecurve.enable || ${anyDesktopText}";
        description = ''
          Whether to install the Luxi fonts and enable fontconfig by default.
          Also selects these fonts in enabled GTK and desktop integrations.
          Enabled by default when `bluecurve.enable` or any desktop integration
          is enabled. The font package requires allowing unfree packages.
        '';
      };
      size = flakeLib.mkFontSizeOption;
    };

    qt.enable = lib.mkEnableOption "Bluecurve styles for Qt 5 and Qt 6" // {
      defaultText = lib.literalExpression "config.bluecurve.enable || config.bluecurve.kde.enable";
      description = ''
        Whether to install and select the Bluecurve styles for both Qt 5 and Qt 6.
        Enabled by default when `bluecurve.enable` or `bluecurve.kde.enable`
        is enabled.
      '';
    };

    kde.enable = lib.mkEnableOption "Bluecurve integration with KDE Plasma" // {
      description = ''
        Whether to configure Bluecurve's Plasma theme, window decorations,
        icons, cursors, and color scheme. Also enables GTK, fonts, and Qt
        by default.
      '';
    };

    mate.enable = lib.mkEnableOption "Bluecurve integration with the MATE desktop" // {
      description = ''
        Whether to configure MATE's GTK, icon, cursor, and Marco window themes.
        Also enables GTK and fonts by default.
      '';
    };

    xfce.enable = lib.mkEnableOption "Bluecurve integration with the Xfce desktop" // {
      description = ''
        Whether to configure Xfce's GTK, icon, cursor, and Xfwm4 window themes.
        Also enables GTK and fonts by default.
      '';
    };

    variant = flakeLib.mkVariantOption ''
      Theme variant used for GTK and the MATE and Xfce window themes.
      Icons, cursors, Qt styles, and the KDE Plasma theme retain the
      standard Bluecurve appearance.
    '';
  };

  config.bluecurve =
    let
      anyDesktop = cfg.kde.enable || cfg.mate.enable || cfg.xfce.enable;
    in
    {
      gtk.enable = lib.mkDefault (cfg.enable || anyDesktop);
      fonts.enable = lib.mkDefault (cfg.enable || anyDesktop);
      qt.enable = lib.mkDefault (cfg.enable || cfg.kde.enable);
    };
}
