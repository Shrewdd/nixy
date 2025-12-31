{ config, lib, ... }:

let
  cfg = config.nixy.stylix;
in
{
  options.nixy.stylix = {
    enable = lib.mkEnableOption "Enable Stylix theming for this profile";

    image = lib.mkOption {
      type = lib.types.path;
      default = ./wallpapers/lake_trees.jpg;
      description = "Wallpaper used by Stylix for palette generation.";
    };

    polarity = lib.mkOption {
      type = lib.types.enum [ "dark" "light" "either" ];
      default = "dark";
      description = "Bias Stylix palette generation toward a dark or light scheme.";
    };

    autoEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether Stylix should auto-enable all supported targets.";
    };

    zenProfileNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "default" ];
      description = "Zen Browser profile names Stylix should theme (HM target requirement).";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = cfg.image;
      polarity = cfg.polarity;
      autoEnable = cfg.autoEnable;
    };

    stylix.homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };

    home-manager.sharedModules = [
      ({ lib, ... }: {
        stylix.targets.zen-browser.profileNames = lib.mkDefault cfg.zenProfileNames;
      })
    ];
  };
}
