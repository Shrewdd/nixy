{ config, lib, pkgs, ... }:

{
  options.hm.shell.fastfetch = {
    enable = lib.mkEnableOption "fastfetch system information tool";
  };

  config = lib.mkIf config.hm.shell.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
}
