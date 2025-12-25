{ lib, pkgs, ... }:
{
  # Keep the same login manager flow as GNOME had, but switch the session
  # to Hyprland for this profile.
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
    autoSuspend = lib.mkDefault true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # NVIDIA-friendly defaults; kept scoped to this Hyprland profile.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
    WLR_NO_HARDWARE_CURSORS = lib.mkDefault "1";
  };
}
