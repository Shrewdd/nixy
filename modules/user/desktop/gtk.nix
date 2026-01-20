{ lib, pkgs, ... }:
{
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
      name = lib.mkDefault "Bibata-Modern-Ice";
      package = lib.mkDefault pkgs.bibata-cursors;
    };
  };

  home.packages = [ pkgs.bibata-cursors ];
}
