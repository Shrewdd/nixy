{ lib, pkgs, ... }:
{

  services.dbus.enable = true;
  security.polkit.enable = true;

  services.displayManager.gdm.enable = lib.mkForce false;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
    WLR_NO_HARDWARE_CURSORS = lib.mkDefault "1";
  };
}
