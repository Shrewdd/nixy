{
  lib,
  pkgs,
  config,
  ...
}: let
  themes = import ./themes.nix;
  themeNames = builtins.attrNames themes;
in {
  imports = [./stylix.nix];

  options.nixy.themeProfile = {
    name = lib.mkOption {
      type = lib.types.enum themeNames;
      default = "rose-pine-moon";
      description = "Theme profile to use (light or dark variant)";
    };

    cursorTheme = lib.mkOption {
      type = lib.types.str;
      default = "Bibata-Modern-Ice";
      description = "Cursor theme name";
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size";
    };
  };

  config = let
    cfg = config.nixy.themeProfile;
    theme = themes.${cfg.name};
  in {
    nixy.stylix = {
      enable = lib.mkForce true;
      image = lib.mkDefault theme.wallpaper;
      polarity = lib.mkDefault theme.polarity;
      base16Scheme = lib.mkDefault theme.base16Scheme;
    };

    stylix.cursor = {
      name = cfg.cursorTheme;
      package = pkgs.bibata-cursors;
      size = cfg.cursorSize;
    };
  };
}
