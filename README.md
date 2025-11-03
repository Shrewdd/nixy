
# nixy - NixOS & Home Manager Config

A minimal NixOS and Home Manager setup for multiple hosts.

## Structure

```
.
├── flake.nix          # Flake entrypoint with host configurations
├── flake.lock         # Flake lockfile
├── hosts/             # Per-host NixOS configs
│   ├── monsoon/       # Monsoon host (NixOS + Home Manager modules)
│   └── nomad/         # Nomad host (NixOS + Home Manager modules)
├── shared/            # Shared resources and Home Manager modules
│   ├── home-manager/  # User configs (shared/, monsoon/, nomad/ subdirs)
│   ├── theme/         # Themes
│   └── wallpapers/    # Wallpapers
└── README.md          # This file
```

- **hosts/**: NixOS system configs per host. Includes Home Manager integration.
- **shared/home-manager/**: Reusable Home Manager modules. `shared/` for common, host-specific for overrides.
- **shared/theme/** & **shared/wallpapers/**: Shared assets.

## Usage

- Build: `nh os boot` (or `nixos-rebuild boot`)
- Update: `nix flake update`
- Check: `nix flake check`

Home Manager modules auto-import from subdirs for easy extension.
