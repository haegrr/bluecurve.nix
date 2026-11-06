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
in
{
  config = lib.mkIf cfg.qt.enable {
    qt = {
      enable = true;
      style = {
        name = "Bluecurve";
        package = [
          flakePackages.bluecurve-qt5
          flakePackages.bluecurve-qt6
        ];
      };
    };
  };
}
