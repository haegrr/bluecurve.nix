{ lib, ... }:
let
  flakeLib = lib.makeExtensible (
    self:
    let
      importFile =
        file:
        import file {
          inherit lib;
          flakeLib = self;
        };
    in
    {
      flake = importFile ./flake.nix;
      options = importFile ./options.nix;

      inherit (self.flake) mkFlake;
      inherit (self.options) mkVariantOption mkFontSizeOption;
    }
  );
in
flakeLib
