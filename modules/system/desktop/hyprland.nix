{ pkgs, lib, ... }:
{
  services.displayManager.gdm.enable = lib.mkForce false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];

    # Ensure screencast/screenshot requests are handled by the Hyprland portal.
    # Without this, the session may pick the GTK portal first, which doesn't
    # provide the screen-share picker under Hyprland.
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      qt6Packages.qtmultimedia
      qt6Packages.qtsvg
      qt6Packages.qtvirtualkeyboard
    ];
  };

  environment.systemPackages = with pkgs; [
    playerctl
    grimblast
    wl-clipboard
    gpu-screen-recorder
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
    XDG_SESSION_TYPE = lib.mkDefault "wayland";
    XDG_SESSION_DESKTOP = lib.mkDefault "Hyprland";
    XDG_CURRENT_DESKTOP = lib.mkDefault "Hyprland";
  };
}
