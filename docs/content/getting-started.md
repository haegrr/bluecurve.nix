# Getting started

Add Bluecurve as a flake input and import its Home Manager module:

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
        config.allowUnfree = true; # Required for the Luxi fonts.
      };

      modules = [
        bluecurve.homeModules.default
        {
          # home.username = "bob";
          # home.homeDirectory = "/home/bob";
          # home.stateVersion = "26.05";

          bluecurve.enable = true;
        }
      ];
    };
  };
}
```

## Fonts and unfree packages

The font integration installs Luxi Sans and Luxi Mono through `font-bh-ttf`,
which nixpkgs classifies as unfree. Enable unfree packages in the package set
used by Home Manager, as above, or disable the font integration:

```nix
bluecurve = {
  enable = true;
  fonts.enable = false;
};
```

With fonts disabled, the module leaves application and desktop font settings
alone.

Next, [configure a desktop integration or theme variant](configuration.md).
