{ config, lib, pkgs, ... }:

{
  options.features.desktop.plasma = {
    enable = lib.mkEnableOption "KDE Plasma 6 desktop environment";
  };

  config = lib.mkIf config.features.desktop.plasma.enable {
    # Display manager
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # Desktop environment
    services.desktopManager.plasma6.enable = true;
  };
}