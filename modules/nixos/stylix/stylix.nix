{
  config,
  lib,
  ...
}: let
  cfg = config.nixy.stylix;
in {
  options.nixy.stylix = {
    enable = lib.mkEnableOption "Enable Stylix theming";

    image = lib.mkOption {
      type = lib.types.path;
      description = "Wallpaper for Stylix palette generation";
    };

    polarity = lib.mkOption {
      type = lib.types.enum ["dark" "light" "either"];
      description = "Color scheme polarity";
    };

    base16Scheme = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = "Custom Base16 color scheme (optional)";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = cfg.image;
      polarity = cfg.polarity;
      autoEnable = true;
      base16Scheme = cfg.base16Scheme;
      homeManagerIntegration = {
        autoImport = true;
        followSystem = true;
      };
    };
  };
}
