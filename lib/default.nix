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

      inherit (self.flake) mkFlake;
    }
  );
in
flakeLib
