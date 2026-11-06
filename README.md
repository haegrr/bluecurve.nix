<p align="center">
  <img src="bluecurve-nix.png" alt="Bluecurve logo">
</p>

# Bluecurve for NixOS & Home Manager

Packages and modules for theming with [Bluecurve](https://github.com/neeeeow/Bluecurve), [Bluecurve-Qt](https://github.com/neeeeow/Bluecurve-Qt) and [Bluecurve-KDE](https://github.com/neeeeow/Bluecurve-KDE).

## Usage example

```nix
{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    bluecurve.url = "github:haegrr/bluecurve.nix";
    bluecurve.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, bluecurve, ... }: {
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        home-manager.nixosModules.home-manager
        {
          nixpkgs.config.allowUnfree = true; # required for fonts

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.bob = {
            imports = [
              bluecurve.homeModules.default
            ];
            home.stateVersion = "26.05";

            bluecurve = {
              enable = true;

              # Individual setting defaults (when enable = true):
              # gtk.enable = true;
              # mate.enable = false;
              # fonts.enable = true;
              # fonts.size = 10;
              # qt.enable = true;
              # kde.enable = false;
              # xfce.enable = false;
            };
          };
        }
      ];
    };
  };
}
```

## Credits
* [neeeeow](https://github.com/neeeeow) for creating [Bluecurve](https://github.com/neeeeow/Bluecurve), [Bluecurve-Qt](https://github.com/neeeeow/Bluecurve-Qt) and [Bluecurve-KDE](https://github.com/neeeeow/Bluecurve-KDE).
