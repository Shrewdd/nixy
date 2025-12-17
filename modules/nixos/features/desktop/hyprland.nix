{ config, lib, pkgs, ... }:

{
  options.features.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager";
  };

  config = lib.mkIf config.features.desktop.hyprland.enable {
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
      (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; }) # SDDM theme
    ];
    
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };
}
