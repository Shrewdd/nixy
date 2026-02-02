# nixy

My personal NixOS configuration. Modular, maintainable, and easy to expand.

## Structure

```
.
├── flake.nix                  # Flake entrypoint with host definitions
├── flake.lock                 # Locked dependency versions
├── hosts/                     # Host-specific configurations
│   ├── aurora/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── monsoon/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── nomad/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── default.nix            # Host definitions consumed by flake.nix
├── modules/
│   ├── shared/
│   │   ├── stylix/
│   │   │   ├── stylix.nix         # Stylix config
│   │   │   ├── theme-profiles.nix # Theme selector
│   │   │   ├── theme/             # Color schemes
│   │   │   └── wallpapers/        # Wallpaper collection
│   ├── system/
│   │   ├── core/              # Base OS defaults (nix, networking, localization, boot)
│   │   ├── desktop/           # Desktop environments (Hyprland, GNOME)
│   │   ├── hardware/          # Audio, Bluetooth, GPU
│   │   ├── packages/          # System package bundles
│   │   ├── profiles/          # System profiles (server, workstation, laptop)
│   │   └── services/          # Services (Flatpak, printing, etc.)
│   └── user/
│       ├── apps/              # User applications (Ghostty, Spotify, Zen, etc.)
│       ├── core/              # User defaults
│       ├── desktop/           # Desktop tweaks (GTK, Hyprland)
│       ├── dev/               # Developer tools (Git, etc.)
│       ├── profiles/          # User profiles
│       └── shell/             # Shell tools (Zsh, Starship, btop, etc.)
└── README.md
```

---