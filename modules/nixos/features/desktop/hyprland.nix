{ config, lib, pkgs, ... }:

{
  options.features.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor";
  };

  config = lib.mkIf config.features.desktop.hyprland.enable {
    programs.hyprland.enable = true;

    # Minimal display manager setup; provides a Hyprland session entry.
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    # Basic Wayland utilities commonly needed by desktop apps.
    environment.systemPackages = with pkgs; [
      wayland
      wayland-protocols
    ];
  };
}
