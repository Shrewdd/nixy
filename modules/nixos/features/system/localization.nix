{ config, lib, pkgs, ... }:

{
  options.features.system.localization = {
    enable = lib.mkEnableOption "Localization settings (timezone, locale, keymap)";
    
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Warsaw";
      description = "System timezone";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "System locale";
    };
    
    polishLocales = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use Polish locale for regional settings (address, measurement, etc.)";
    };

    keyMap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Console keymap";
    };
  };

  config = lib.mkIf config.features.system.localization.enable {
    time.timeZone = config.features.system.localization.timeZone;

    i18n = {
      defaultLocale = config.features.system.localization.locale;
      extraLocaleSettings = lib.mkIf config.features.system.localization.polishLocales {
        LC_ADDRESS = "pl_PL.UTF-8";
        LC_IDENTIFICATION = "pl_PL.UTF-8";
        LC_MEASUREMENT = "pl_PL.UTF-8";
        LC_MONETARY = "pl_PL.UTF-8";
        LC_NAME = "pl_PL.UTF-8";
        LC_NUMERIC = "pl_PL.UTF-8";
        LC_PAPER = "pl_PL.UTF-8";
        LC_TELEPHONE = "pl_PL.UTF-8";
        LC_TIME = "pl_PL.UTF-8";
      };
    };

    console.keyMap = config.features.system.localization.keyMap;
  };
}
