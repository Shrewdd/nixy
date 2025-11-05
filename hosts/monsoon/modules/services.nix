{ config, pkgs, ... }:

{
  # ===================================
  # Services Configuration
  # ===================================

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
  };

  # Enable udev for GNOME DE
  services.udev.packages = with pkgs; [ gnomeExtensions.appindicator ];

}
