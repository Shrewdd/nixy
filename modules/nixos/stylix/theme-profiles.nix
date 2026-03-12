{
  lib,
  pkgs,
  config,
  ...
}: let
  themes = import ./themes.nix {inherit pkgs;};
  themeNames = builtins.attrNames themes;
in {
  imports = [./stylix.nix];

  options.nixy.themeProfile = {
    name = lib.mkOption {
      type = lib.types.enum themeNames;
      default = "rose-pine";
      description = "Theme profile to use (light or dark variant)";
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
      wallpaperDir = lib.mkDefault theme.wallpaperDir;
      polarity = lib.mkDefault theme.polarity;
      base16Scheme = lib.mkDefault theme.base16Scheme;
    };

    stylix.cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = cfg.cursorSize;
    };
  };
}
