{ config, pkgs, ... }:

{
  # ===================================
  # Services Configuration
  # ===================================

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
  };

  # Enable flatpak support
  services.flatpak = {
    enable = true;
  };

}
