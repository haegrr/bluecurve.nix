{
  inputs = {
    bluecurve.url = "..";
    nixpkgs.follows = "bluecurve/nixpkgs";
  };

  outputs =
    { bluecurve, nixpkgs, ... }:
    {
      packages = nixpkgs.lib.genAttrs [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ] (
        system:
        import ./default.nix {
          inherit bluecurve;
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );
    };
}
