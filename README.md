# nixy - Modular NixOS configuration (I suppose)

A clean, feature-based NixOS configuration with Home Manager integration. Built for maintainability and easy expansion.

## Structure

```
.
├── flake.nix                  # Flake entrypoint with host definitions
├── flake.lock                 # Locked dependency versions
├── hosts/                     # Host-specific configuration
│   ├── monsoon/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── nomad/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/
│   │   ├── features/          # Individual system features (audio, bluetooth, etc.)
│   │   │   ├── desktop/
│   │   │   ├── hardware/
│   │   │   ├── services/
│   │   │   ├── system/
│   │   │   └── packages.nix
│   │   └── profiles/          # Feature bundles (base, desktop, laptop)
│   └── home-manager/
│       ├── features/          # User-level features (shell, apps, theming)
│       │   ├── apps/
│       │   ├── desktop/
│       │   ├── dev/
│       │   └── shell/
│       └── profiles/          # User bundles (base, desktop)
├── assets/
│   ├── theme/                 # Color schemes (for future use)
│   └── wallpapers/            # Wallpaper collection
└── README.md
```

## Notes

- Flakes and nix-command are enabled by default
- Automatic store optimization and weekly garbage collection configured
- GNOME automatically disables blueman (uses built-in bluetooth management)
- Hyprland/other DEs will use blueman by default (conditional logic in bluetooth.nix)
- Home Manager backups enabled (`.backup` extension for conflicting files)

---