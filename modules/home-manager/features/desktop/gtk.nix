{ config, lib, pkgs, ... }:

{
  options.hm.desktop.gtk = {
    enable = lib.mkEnableOption "GTK configuration and theming";
  };

  config = lib.mkIf config.hm.desktop.gtk.enable {
    gtk = {
      enable = true;
      
      theme = {
        name = lib.mkDefault "Adwaita-dark";
        package = lib.mkDefault pkgs.gnome-themes-extra;
      };
      
      iconTheme = {
        name = lib.mkDefault "Adwaita";
        package = lib.mkDefault pkgs.adwaita-icon-theme;
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
    };

    # Ensure cursor package is available
    home.packages = [ pkgs.bibata-cursors ];
  };
}
