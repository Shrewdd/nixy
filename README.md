# nixy

my personal nixos configuration! this is made for my machines
and probably won't work on yours without changes, but feel free
to look around and steal whatever is useful.

## structure

```
.
├── flake.nix                          # entrypoint, host definitions
├── hosts/
│   ├── default.nix                    # host list consumed by flake.nix
│   ├── monsoon/                       # desktop
│   └── nomad/                         # laptop
├── modules/
│   ├── profiles/
│   │   ├── hyprland.nix               # full Hyprland desktop profile
│   ├── nixos/
│   │   ├── core.nix                   # users, nix settings, networking, boot, locale
│   │   ├── audio.nix                  # PipeWire
│   │   ├── bluetooth.nix              # Bluetooth
│   │   ├── flatpak.nix                # Flatpak
│   │   ├── thunar.nix                 # thunar file manager
│   │   ├── packages.nix               # shared system packages
│   │   ├── printing.nix               # CUPS
│   │   └── stylix/                    # theming (Stylix, base16 schemes, wallpapers)
│   └── home/
│       ├── core.nix                   # HM base (imports shell + git)
│       ├── shell.nix                  # fish, starship, btop, fastfetch
│       ├── git.nix                    # git config
│       ├── kitty.nix                  # kitty terminal
│       ├── zen.nix                    # Zen browser
│       └── spotify.nix                # Spicetify
└── README.md
```

---