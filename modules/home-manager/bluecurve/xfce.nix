_:
{ lib, config, ... }:
let
  cfg = config.bluecurve;
in
{
  config = lib.mkIf cfg.xfce.enable {
    xfconf.settings = {
      xfwm4 = {
        "general/theme" = cfg.variant;
      };
      xsettings = {
        "Net/ThemeName" = cfg.variant;
        "Net/IconThemeName" = "Bluecurve";
        "Gtk/CursorThemeName" = "Bluecurve";
      }
      // lib.optionalAttrs cfg.fonts.enable {
        "Gtk/FontName" = "Luxi Sans ${toString cfg.fonts.size}";
        "Gtk/MonospaceFontName" = "Luxi Mono ${toString cfg.fonts.size}";
      };
    };
  };
}
