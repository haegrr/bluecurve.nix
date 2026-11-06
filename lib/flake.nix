{ lib, ... }:

let
  eachSystemWithInputs =
    inputs: systems: f:
    lib.genAttrs systems (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        inputs' = lib.mapAttrs (_: input: {
          packages = input.packages.${system};
          formatter = input.formatter.${system};
        }) inputs;
      in
      f {
        inherit
          pkgs
          system
          inputs
          inputs'
          ;
        inherit (inputs) self;
        self' = inputs'.self;
      }
    );

  mkFlake =
    inputs: f:
    f rec {
      eachSystem = eachSystemWithInputs inputs;
      allSystems = eachSystem lib.systems.flakeExposed;
    };
in
{
  inherit mkFlake;
}
