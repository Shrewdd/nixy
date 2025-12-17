{ lib, pkgs, ... }:
{
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
    autoSuspend = lib.mkDefault true;
  };

  services.desktopManager.gnome.enable = true;
  services.blueman.enable = lib.mkForce false;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-tour
    geary
    yelp
  ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome-settings-daemon
  ];

  services.tlp.enable = lib.mkForce false;

  services.udev.packages = with pkgs; [ gnomeExtensions.appindicator ];
}
