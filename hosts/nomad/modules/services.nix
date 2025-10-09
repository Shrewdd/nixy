{ pkgs, ... }:

{
  # GNOME AppIndicator tray support
  services.udev = {
    packages = [ pkgs.gnome-settings-daemon ];
  };
}
