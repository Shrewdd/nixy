{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options.hm.apps.zen = {
    enable = lib.mkEnableOption "Zen Browser";
  };

  config = lib.mkIf config.hm.apps.zen.enable {
    programs.zen-browser = {
      enable = true;
      
      policies = {
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        DisableFirefoxStudies = true;
        NoDefaultBookmarks = true;
      };

      profiles.default = {
        id = 0;
        settings = {
          "browser.startup.page" = 3;
        };
      };
    };
  };
}
