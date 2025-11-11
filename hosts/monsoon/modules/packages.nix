{ config, pkgs, lib, ... }:
{
  # ===================================
  # FONTS
  # ===================================
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # ===================================
  # APPLICATIONS & UTILITIES
  # ===================================
  environment.systemPackages = with pkgs; [
    vesktop                    # Discord client
    appimage-run               # AppImage support
    lutris                     # Game installer/runner
    sixpair                    # PS3 controller pairing
    veracrypt                  # Disk encryption
    kdePackages.gwenview       # Image viewer
    lshw                       # PCIe Hardware info
    speedtest-cli              # Internet speed test
    # ROBLOX DEVELOPMENT
    rojo                       # Roblox Development Tool
    wally                      # Roblox Package Manager
    selene                     # Lua Linter
    luau-lsp                   # Luau Language Server
    stylua                     # Lua Formatter
  ];

  # ===================================
  # APPLICATIONS WITH OPTIONS
  # ===================================
  programs.dconf = {
    enable = true;
  };
  # programs.localsend, programs.nh and programs.zoom-us are now
  # provided by `shared/nixos/packages.nix` and are available when that
  # module is imported by the host configuration.

  programs.gamemode = {
    enable = true;
  };

  programs.steam.enable = true;
  

  # ===================================
  # GNOME EXCLUSIONS
  # ===================================
  environment.gnome.excludePackages = (with pkgs; [
    epiphany
    geary
    gnome-tour
  ]);
}
