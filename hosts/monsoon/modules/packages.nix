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
    vscode                     # VSCode editor
    appimage-run               # AppImage support
    sixpair                    # PS3 controller pairing
    veracrypt                  # Disk encryption
    kdePackages.gwenview       # Image viewer
    lshw                       # PCIe Hardware info
    simple-scan                # Document Scanner
    papers                     # Document Viewer
    speedtest-cli              # Internet speed test
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; }) # SDDM theme
    # ROBLOX DEVELOPMENT
    rojo                       # Roblox Development Tool
    wally                      # Roblox Package Manager
  ];

  # ===================================
  # APPLICATIONS WITH OPTIONS
  # ===================================
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.nh = {
  enable = true;
  clean.enable = true;
  clean.extraArgs = "--keep-since 4d --keep 3";
  flake = "/home/km/nixy";
  };

  programs.zoom-us = {
  enable = true;
  };

  programs.gamemode = {
    enable = true;
  };
}
