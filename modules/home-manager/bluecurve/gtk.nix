_:
{ lib, config, ... }:
let
  cfg = config.bluecurve;
in
{
  config = lib.mkIf cfg.gtk.enable {
    gtk = {
      enable = true;

      theme = {
        name = cfg.variant;
        inherit (cfg.gtk) package;
      };

      iconTheme = {
        name = "Bluecurve";
        inherit (cfg.gtk) package;
      };

      cursorTheme = {
        name = "Bluecurve";
        inherit (cfg.gtk) package;
      };

      font = lib.mkIf cfg.fonts.enable {
        name = "Luxi Sans";
        size = cfg.fonts.size;
      };
    };
  };
}
