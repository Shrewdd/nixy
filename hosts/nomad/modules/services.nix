{ pkgs, ... }:

{
  # ===================================
  # Services Configuration
  # ===================================

  # GNOME AppIndicator / udev helpers (desktop integrations)
  services.udev = {
    packages = [ pkgs.gnome-settings-daemon ];
  };

  # Enable CUPS to print documents
  services.printing = {
    enable = true;
  };

  # Enable touchpad support (libinput)
  services.libinput = {
    enable = true;
  };

  # Enable flatpak support
  services.flatpak = {
    enable = true;
  };

}
