{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  home.packages = [ pkgs.bibata-cursors ];
}