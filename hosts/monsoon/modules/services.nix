{ config, pkgs, ... }:

{
  # ===================================
  # Services Configuration
  # ===================================

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
  };

  # Enable Avahi for mDNS resolution (.local names)
  services.avahi = {
    enable = true;
    openFirewall = true;
  };

  # Enable udev for GNOME DE
  services.udev.packages = with pkgs; [ gnomeExtensions.appindicator ];

}
