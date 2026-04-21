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
│   ├── aurora/                        # headless dev server (PostgreSQL, Prisma)
│   ├── monsoon/                       # desktop workstation (Hyprland, Nvidia)
│   └── nomad/                         # laptop (GNOME)
├── modules/
│   ├── profiles/
│   │   ├── hyprland.nix               # full Hyprland desktop profile
│   │   ├── gnome.nix                  # full GNOME desktop profile
│   ├── nixos/
│   │   ├── core.nix                   # users, nix settings, networking, boot, locale
│   │   ├── audio.nix                  # PipeWire
│   │   ├── bluetooth.nix              # Bluetooth
│   │   ├── flatpak.nix                # Flatpak
│   │   ├── nautilus.nix               # Nautilus file manager
│   │   ├── packages.nix               # shared system packages
│   │   ├── printing.nix               # CUPS
│   │   └── stylix/                    # theming (Stylix, base16 schemes, wallpapers)
│   └── home/
│       ├── core.nix                   # HM base (imports shell + git)
│       ├── shell.nix                  # fish, starship, btop, fastfetch
│       ├── git.nix                    # git config
│       ├── ghostty.nix                # Ghostty terminal
│       ├── zen.nix                    # Zen browser
│       └── spotify.nix                # Spicetify
└── README.md
```

---

## rbw setup (new install) cuz im dum dum

```bash
rbw config set email you@example.com
rbw config set base_url https://api.bitwarden.eu
rbw register
rbw login
rbw sync
```