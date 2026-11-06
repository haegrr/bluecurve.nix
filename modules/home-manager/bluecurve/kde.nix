{ mkFlakePackages, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.bluecurve;
  flakePackages = mkFlakePackages pkgs;
  applyColorScheme = pkgs.writeShellApplication {
    name = "bluecurve-apply-colorscheme";
    runtimeInputs = [
      pkgs.kdePackages.kconfig
      pkgs.kdePackages.plasma-workspace
    ];
    runtimeEnv.XDG_CONFIG_HOME = config.xdg.configHome;
    text = ''
      # KDE skips applying a scheme if its name is already selected.
      kwriteconfig6 --file "$XDG_CONFIG_HOME/kdeglobals" \
        --group General --key ColorScheme ""

      export XDG_DATA_DIRS="${flakePackages.bluecurve-qt6}/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
      plasma-apply-colorscheme -platform offscreen Bluecurve
    '';
  };
  kdeFont = name: "${name},${toString cfg.fonts.size},-1,5,50,0,0,0,0,0";
in
{
  config = lib.mkIf cfg.kde.enable {
    home.packages = [
      (flakePackages.bluecurve-kde.override {
        bluecurve = cfg.gtk.package;
      })
    ];

    home.activation.bluecurveColors = lib.hm.dag.entryAfter [
      "installPackages"
      "kconfig"
    ] "run ${lib.getExe applyColorScheme}";

    qt.kde.settings = {
      kdeglobals = {
        General = lib.optionalAttrs cfg.fonts.enable {
          font = kdeFont "Luxi Sans";
          fixed = kdeFont "Luxi Mono";
          menuFont = kdeFont "Luxi Sans";
          smallestReadableFont = kdeFont "Luxi Sans";
          taskbarFont = kdeFont "Luxi Sans";
          toolBarFont = kdeFont "Luxi Sans";
        };
        Icons.Theme = "Bluecurve";
        KDE = {
          LookAndFeelPackage = "com.github.haegrr.bluecurve.desktop";
          widgetStyle = "Bluecurve";
        };
        WM = lib.optionalAttrs cfg.fonts.enable {
          activeFont = kdeFont "Luxi Sans";
        };
      };
      kcminputrc.Mouse.cursorTheme = "Bluecurve";
      kwinrc."org.kde.kdecoration2".library = "com.github.neeeeow.bluecurve";
      plasmarc.Theme.name = "Bluecurve";
    };
  };
}
