_:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.bluecurve;
in
{
  config = lib.mkIf cfg.fonts.enable {
    fonts = {
      fontconfig.enable = lib.mkDefault true;
      packages = [ pkgs.font-bh-ttf ];
    };
  };
}
