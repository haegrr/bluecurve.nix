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
  gtkOptions = {
    options = {
      enable = lib.mkEnableOption "bluecurve.gtk";
      package = lib.mkPackageOption flakePackages "bluecurve" { };
    };
  };
  mateOptions = {
    options = {
      enable = lib.mkEnableOption "bluecurve.mate";
    };
  };
  fontsOptions = {
    options = {
      enable = lib.mkEnableOption "bluecurve.fonts";
      size = lib.mkOption {
        type = lib.types.ints.positive;
        default = 10;
        description = "Point size for Bluecurve UI fonts.";
      };
    };
  };
  qtOptions = {
    options = {
      enable = lib.mkEnableOption "bluecurve.qt";
    };
  };
  kdeOptions = {
    options = {
      enable = lib.mkEnableOption "bluecurve.kde";
    };
  };
  xfceOptions = {
    options = {
      enable = lib.mkEnableOption "bluecurve.xfce";
    };
  };
in
{
  options.bluecurve = {
    enable = lib.mkEnableOption "bluecurve";

    gtk = lib.mkOption {
      type = lib.types.submodule gtkOptions;
    };

    mate = lib.mkOption {
      type = lib.types.submodule mateOptions;
    };

    fonts = lib.mkOption {
      type = lib.types.submodule fontsOptions;
    };

    qt = lib.mkOption {
      type = lib.types.submodule qtOptions;
    };

    kde = lib.mkOption {
      type = lib.types.submodule kdeOptions;
    };

    xfce = lib.mkOption {
      type = lib.types.submodule xfceOptions;
    };

    variant = lib.mkOption {
      type = lib.types.enum [
        "Bluecurve"
        "Bluecurve-BerriesAndCream"
        "Bluecurve-Gnome"
        "Bluecurve-Grape"
        "Bluecurve-Lime"
        "Bluecurve-Slate"
        "Bluecurve-Strawberry"
        "Bluecurve-Tangerine"
      ];
      default = "Bluecurve";
    };
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
