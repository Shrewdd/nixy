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
    rojo                       # Roblox development tool
    lshw                       # PCIe Hardware info
  ];

  # ===================================
  # APPLICATIONS WITH OPTIONS
  # ===================================
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
