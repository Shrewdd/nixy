{ pkgs, ... }:

{
  #######################
  # FONTS
  #######################
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  ##########################
  # APPLICATIONS & UTILITIES
  ##########################
  environment.systemPackages = with pkgs; [
    pavucontrol                # Audio control
    playerctl                  # Media player control
    jq                         # JSON processor
    curl                       # Data transfer tool
    brightnessctl              # Screen brightness
    libsecret                  # Secrets storage
    seahorse                   # GNOME key manager
    xarchiver                  # Archive manager
    appimage-run               # AppImage support
    sixpair                    # PS3 controller pairing
    veracrypt                  # Disk encryption
    kdePackages.gwenview       # Image viewer
    libnotify                  # Desktop notifications
    grimblast                  # Screenshot utility
    wl-clipboard               # Wayland clipboard (required by cliphist)
    hyprpolkitagent            # Hyprland polkit agent
    rojo                       # Roblox development tool
    lshw
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; }) # SDDM theme
  ];

  ###########################
  # APPLICATIONS WITH OPTIONS
  ###########################
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.steam = {
    enable = true;
  };

  programs.thunar = {
    enable = true;
  };
}
