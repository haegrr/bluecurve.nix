_:
{ lib, config, ... }:
let
  cfg = config.bluecurve;
in
{
  config = lib.mkIf cfg.mate.enable {
    dconf.settings = {
      "org/mate/desktop/interface" = {
        gtk-theme = cfg.variant;
        icon-theme = "Bluecurve";
      }
      // lib.optionalAttrs cfg.fonts.enable {
        font-name = "Luxi Sans ${toString cfg.fonts.size}";
        monospace-font-name = "Luxi Mono ${toString cfg.fonts.size}";
      };
      "org/mate/desktop/peripherals/mouse".cursor-theme = "Bluecurve";
      "org/mate/marco/general".theme = cfg.variant;
    };
  };
}
