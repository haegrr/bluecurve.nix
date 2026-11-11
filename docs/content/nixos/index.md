# NixOS

The NixOS module themes LightDM's GTK greeter, which runs before any user logs
in and therefore cannot be configured with Home Manager

## Getting started

Add Bluecurve as a flake input and import its NixOS module:

```nix
{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

    bluecurve.url = "github:haegrr/bluecurve.nix";
    bluecurve.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, bluecurve, ... }: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      modules = [
        bluecurve.nixosModules.default
        {
          # Required for the Luxi fonts.
          nixpkgs.config.allowUnfreePredicate =
            pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "font-bh-ttf" ];

          services.xserver.enable = true;
          services.xserver.displayManager.lightdm.enable = true;

          bluecurve.enable = true;
        }
      ];
    };
  };
}
```

## Feature defaults

| Configuration                     | LightDM GTK greeter | Fonts |
| --------------------------------- | ------------------- | ----- |
| `bluecurve.enable = true`         | On                  | On    |
| `bluecurve.lightdm.enable = true` | On                  | On    |
| `bluecurve.fonts.enable = true`   | Off                 | On    |

## LightDM GTK greeter

```nix
bluecurve.lightdm.enable = true;
```

Sets the greeter's GTK theme, icon theme, and cursor theme to Bluecurve
through `services.xserver.displayManager.lightdm.greeters.gtk`. When fonts are
enabled, the greeter also uses Luxi Sans at `bluecurve.fonts.size` points.

## Theme variants

```nix
bluecurve = {
  enable = true;
  variant = "Bluecurve-Slate";
};
```

The [variant option](../nixos-options.md#bluecurvevariant) lists all supported
values. The variant selects the greeter's GTK theme. Icons and cursors retain
the standard Bluecurve appearance.

## Fonts

With fonts enabled, Luxi Sans and Luxi Mono are installed system-wide through
`font-bh-ttf`, which nixpkgs classifies as unfree, and fontconfig is enabled.
Allow that package, as above, or set `bluecurve.fonts.enable = false` and leave
the greeter on its default font.

The default size is 10 points:

```nix
bluecurve.fonts.size = 12;
```
