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
    fonts.fontconfig.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      font-bh-ttf
    ];
  };
}
