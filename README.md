<p align="center">
  <img src="docs/content/assets/bluecurve-nix.png" alt="Bluecurve logo">
</p>

# Bluecurve for NixOS & Home Manager

Packages and modules for theming with [Bluecurve](https://github.com/neeeeow/Bluecurve), [Bluecurve-Qt](https://github.com/neeeeow/Bluecurve-Qt) and [Bluecurve-KDE](https://github.com/neeeeow/Bluecurve-KDE).

**[Documentation](https://docs.rtin.foo/bluecurve.nix/)** · [Getting started](https://docs.rtin.foo/bluecurve.nix/getting-started/) · [Options](https://docs.rtin.foo/bluecurve.nix/options/)

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
    homeConfigurations.bob = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true; # Required for Luxi fonts.
      };
      modules = [
        bluecurve.homeModules.default
        {
          home.username = "bob";
          home.homeDirectory = "/home/bob";
          home.stateVersion = "26.05";

          bluecurve = {
            enable = true;
            # fonts.enable = false; # Avoid the unfree font package.
            # kde.enable = true;    # Desktop integrations are opt-in.
          };
        }
      ];
    };
  };
}
```

## Credits
* [neeeeow](https://github.com/neeeeow) for creating [Bluecurve](https://github.com/neeeeow/Bluecurve), [Bluecurve-Qt](https://github.com/neeeeow/Bluecurve-Qt) and [Bluecurve-KDE](https://github.com/neeeeow/Bluecurve-KDE).
