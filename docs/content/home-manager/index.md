# Home Manager

The Home Manager module themes GTK, Qt, and desktop environments (MATE, KDE
Plasma, Xfce) for a user.

## Getting started

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

  outputs =
    {
      nixpkgs,
      home-manager,
      bluecurve,
      ...
    }:
    {
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

## Feature defaults

| Configuration                  | GTK | Fonts | Qt  | Desktop integration |
| ------------------------------ | --- | ----- | --- | ------------------- |
| `bluecurve.enable = true`      | On  | On    | On  | None                |
| `bluecurve.kde.enable = true`  | On  | On    | On  | KDE Plasma          |
| `bluecurve.mate.enable = true` | On  | On    | Off | MATE                |
| `bluecurve.xfce.enable = true` | On  | On    | Off | Xfce                |

Defaults use `mkDefault`, so any feature can be set explicitly, for example
`bluecurve.qt.enable = false`.

## Desktop integrations

### KDE Plasma

```nix
bluecurve.kde.enable = true;
```

Configures the Plasma theme, window decorations, icons, cursors, and color
scheme.

### MATE

```nix
bluecurve.mate.enable = true;
```

Configures GTK, icons, cursors, and the Marco window theme through dconf.

### Xfce

```nix
bluecurve.xfce.enable = true;
```

Configures GTK, icons, cursors, and the Xfwm4 window theme through xfconf.

## Theme variants

```nix
bluecurve = {
  enable = true;
  variant = "Bluecurve-Slate";
};
```

The [variant option](../options.md#bluecurvevariant) lists all supported values.
It selects the GTK theme and the MATE/Xfce window themes. Icons, cursors, Qt
styles, and the KDE Plasma theme retain the standard Bluecurve appearance.

## Fonts

The font integration installs Luxi Sans and Luxi Mono through `font-bh-ttf`,
which nixpkgs classifies as unfree. Enable unfree packages in the package set
used by Home Manager, as above, or disable the font integration:

```nix
bluecurve = {
  enable = true;
  fonts.enable = false;
};
```

The default size is 10 points. It applies wherever an enabled GTK or desktop
integration selects Luxi fonts:

```nix
bluecurve.fonts.size = 12;
```
