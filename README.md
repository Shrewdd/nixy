# nixy - Modular NixOS configuration (I suppose)

A clean, feature-based NixOS configuration with Home Manager integration. Built for maintainability and easy expansion.

## Structure

```
.
├── flake.nix                  # Flake entrypoint with host definitions
├── flake.lock                 # Locked dependency versions
├── hosts/                     # Host manifests and configurations
│   ├── aurora/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── monsoon/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── nomad/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── default.nix            # Shared host definitions consumed by flake.nix
├── modules/
│   ├── shared/
│   │   ├── theme/             # Color palettes for reuse
│   │   └── wallpapers/        # Shared wallpaper collection
│   ├── system/
│   │   ├── core/              # Base OS defaults (nix, networking, localization)
│   │   ├── desktop/           # Desktop environment modules (GNOME only for now)
│   │   ├── hardware/          # Audio, bluetooth, GPU helpers
│   │   ├── packages/          # Package bundles per role
│   │   ├── profiles/          # Host roles (server, workstation, laptop)
│   │   └── services/          # Flatpak, printing, etc.
│   └── user/
│       ├── apps/              # Home Manager application modules
│       ├── core/              # Shared user defaults
│       ├── desktop/           # User-level desktop tweaks (GNOME, GTK)
│       ├── dev/               # Developer tooling (git)
│       ├── profiles/          # User bundles (server, desktop)
│       └── shell/             # Shell tooling (zsh, starship, etc.)
└── README.md
```

## Notes

- Flakes and nix-command are enabled by default
- Automatic store optimization and weekly garbage collection configured

---