{ pkgs, ... }:

{
  # GNOME AppIndicator tray support
  services.udev = {
    packages = [ pkgs.gnome-settings-daemon ];
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
  };
}
