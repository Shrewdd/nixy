{ config, lib, pkgs, inputs, ... }:

{
  options.hm.apps.zen = {
    enable = lib.mkEnableOption "Zen Browser";
  };

  config = lib.mkIf config.hm.apps.zen.enable {
    home.packages = [ inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
