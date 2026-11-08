# Configuration

## Feature defaults

| Configuration                  | GTK | Fonts | Qt  | Desktop integration |
| ------------------------------ | --- | ----- | --- | ------------------- |
| `bluecurve.enable = true`      | On  | On    | On  | None                |
| `bluecurve.kde.enable = true`  | On  | On    | On  | KDE Plasma          |
| `bluecurve.mate.enable = true` | On  | On    | Off | MATE                |
| `bluecurve.xfce.enable = true` | On  | On    | Off | Xfce                |

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

The [variant option](options.md#bluecurvevariant) lists all supported values.
It selects the GTK theme and the MATE/Xfce window themes. Icons, cursors, Qt
styles, and the KDE Plasma theme retain the standard Bluecurve appearance.

## Font size

```nix
bluecurve.fonts.size = 12;
```

The default is 10 points. This setting applies where an enabled GTK or desktop
integration selects Luxi fonts.
