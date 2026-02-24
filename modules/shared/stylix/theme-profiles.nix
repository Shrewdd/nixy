{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [./stylix.nix];

  options.nixy.themeProfile = {
    name = lib.mkOption {
      type = lib.types.enum ["catppuccin-latte" "catppuccin-mocha" "rose-pine-moon" "rose-pine-dawn"];
      default = "catppuccin-mocha";
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
    themes = {
      catppuccin-latte = {
        wallpaper = ./wallpapers/catppuccin-latte/white-snow-and-a-tree_light.png;
        base16Scheme = import ./theme/catppuccin-latte-base16.nix;
        polarity = "light";
      };
      catppuccin-mocha = {
        wallpaper = ./wallpapers/catppuccin-mocha/sunset.png;
        base16Scheme = import ./theme/catppuccin-mocha-base16.nix;
        polarity = "dark";
      };
      rose-pine-moon = {
        wallpaper = ./wallpapers/rose-pine-moon/pink-clouds.png;
        base16Scheme = import ./theme/rose-pine-moon-base16.nix;
        polarity = "dark";
      };
      rose-pine-dawn = {
        wallpaper = ./wallpapers/rose-pine-moon/pink-clouds.png;
        base16Scheme = import ./theme/rose-pine-dawn-base16.nix;
        polarity = "light";
      };
    };
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
