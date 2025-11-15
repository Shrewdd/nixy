{ config, lib, pkgs, ... }:

{
  options.hm.shell.btop = {
    enable = lib.mkEnableOption "btop system monitor";
  };

  config = lib.mkIf config.hm.shell.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
        vim_keys = true;
      };
    };
  };
}
