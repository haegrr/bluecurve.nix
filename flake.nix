{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      flakeLib = import ./lib {
        inherit lib;
      };

      mkFlakePackages =
        pkgs:
        let
          packages = lib.packagesFromDirectoryRecursive {
            directory = ./packages;
            callPackage = lib.callPackageWith (pkgs // packages);
          };
        in
        packages;

      importApply = (lib.flip lib.modules.importApply) {
        inherit
          self
          inputs
          flakeLib
          importApply
          mkFlakePackages
          ;
      };
    in
    flakeLib.mkFlake inputs (
      { eachSystem, allSystems, ... }:
      {
        packages = eachSystem [ "aarch64-linux" "x86_64-linux" ] ({ pkgs, ... }: mkFlakePackages pkgs);

        overlays.default = final: _prev: mkFlakePackages final;

        homeModules.default = {
          imports = map importApply [
            ./modules/home-manager/bluecurve
          ];
        };

        formatter = allSystems (
          { pkgs, ... }:
          (pkgs.treefmt.evalConfig ./treefmt.nix).config.result
        );

        checks = allSystems (
          { pkgs, self', ... }: {
            format = self'.formatter.check ./.;
            lint =
              pkgs.runCommand "lint"
                {
                  nativeBuildInputs = with pkgs; [
                    statix
                    deadnix
                  ];
                }
                ''
                  statix check ${./.}
                  deadnix --fail ${./.}
                  touch $out
                '';
          }
        );

        ci = self.packages // self.checks.x86_64-linux;
      }
    );
}
