
# nixy - My Nix & Home Manager Structure

This is my Nix and Home Manager setup. Here’s a quick overview of what each folder is for:


```
.
├── home-manager/    # All my user-level configs and modules
│   ├── hyprland/    # Hyprland window manager config
│   ├── dunst/       # Notification daemon config
│   ├── rofi/        # App launcher config
│   ├── waybar/      # Status bar config
│   ├── shell/       # Shell and CLI tools
│   └── ...          # Other stuff I use or import
├── hosts/           # Per-machine configs (each folder is a user or host)
│   └── monsoon/     # Example: configs for the 'monsoon' machine
│   └── ...          # More hosts/users as needed
├── shared/          # Shared resources (themes, wallpapers, etc.)
│   ├── theme/       # Centralized theme files
│   └── wallpapers/  # My wallpapers
├── flake.nix        # Nix flake entrypoint
├── flake.lock       # Nix flake lockfile
└── ...
```

- **home-manager/**: All my user-level configuration. Modules for window managers, launchers, shell tools, and more. I import what I need from here.
- **hosts/**: Per-machine or per-user configs. Each folder is for a specific host or user.
- **shared/**: Themes, wallpapers, and resources I use across different configs.

For details, just check the relevant folder or config file.
