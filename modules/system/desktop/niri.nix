{ inputs, lib, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  services.displayManager.gdm.enable = lib.mkForce false;

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

  programs.niri = {
    enable = true;
    useNautilus = true;
  };

  environment.systemPackages = with pkgs; [
    playerctl
    xwayland-satellite
    bibata-cursors
    swww
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
  };
}
