_:
{ lib, config, ... }:
let
  cfg = config.bluecurve;
in
{
  config = lib.mkIf cfg.lightdm.enable {
    services.xserver.displayManager.lightdm.greeters.gtk = {
      theme = {
        name = lib.mkDefault cfg.variant;
        package = lib.mkDefault cfg.lightdm.package;
      };

      iconTheme = {
        name = lib.mkDefault "Bluecurve";
        package = lib.mkDefault cfg.lightdm.package;
      };

      cursorTheme = {
        name = lib.mkDefault "Bluecurve";
        package = lib.mkDefault cfg.lightdm.package;
      };

      extraConfig = lib.mkIf cfg.fonts.enable ''
        font-name = Luxi Sans ${toString cfg.fonts.size}
      '';
    };
  };
}
