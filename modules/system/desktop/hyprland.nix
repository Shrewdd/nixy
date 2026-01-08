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
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
  };
}
