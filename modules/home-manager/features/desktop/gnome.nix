{ config, lib, pkgs, ... }:

{
  options.hm.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop user configuration";
  };

  config = lib.mkIf config.hm.desktop.gnome.enable {
    # dconf settings for GNOME
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
