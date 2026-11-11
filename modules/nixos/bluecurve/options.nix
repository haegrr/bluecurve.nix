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
in
{
  options.bluecurve = {
    enable = lib.mkEnableOption "Bluecurve's system-level integrations" // {
      description = ''
        Whether to enable Bluecurve's system-level integrations by default.
        Currently this covers the LightDM GTK greeter and its fonts.
      '';
    };

    lightdm = {
      enable =
        lib.mkEnableOption "Bluecurve theme, icons, cursors, and fonts in LightDM's GTK greeter"
        // {
          defaultText = lib.literalExpression "config.bluecurve.enable";
          description = ''
            Whether to apply Bluecurve to the LightDM GTK greeter.
            Enabled by default when `bluecurve.enable` is enabled.
          '';
        };
      package = lib.mkPackageOption flakePackages "bluecurve" {
        pkgsText = "bluecurve.packages.\${pkgs.stdenv.hostPlatform.system}";
      };
    };

    fonts = {
      enable = lib.mkEnableOption "Bluecurve's Luxi fonts" // {
        defaultText = lib.literalExpression "config.bluecurve.enable || config.bluecurve.lightdm.enable";
        description = ''
          Whether to install the Luxi fonts system-wide and enable fontconfig
          by default. Also selects these fonts in enabled integrations.
          Enabled by default when `bluecurve.enable` or any integration is
          enabled. The font package requires allowing unfree packages.
        '';
      };
      size = flakeLib.mkFontSizeOption;
    };

    variant = flakeLib.mkVariantOption ''
      Theme variant used for the GTK theme. Icons and cursors retain the
      standard Bluecurve appearance.
    '';
  };

  config.bluecurve = {
    lightdm.enable = lib.mkDefault cfg.enable;
    fonts.enable = lib.mkDefault (cfg.enable || cfg.lightdm.enable);
  };
}
