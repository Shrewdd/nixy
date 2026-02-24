{
  lib,
  config,
  ...
}: let
  # Available themes (must match theme-profiles.nix enum)
  availableThemes = [
    "catppuccin-latte"
    "catppuccin-mocha"
    "rose-pine-moon"
    "rose-pine-dawn"
  ];

  # Create a specialisation for each theme
  mkThemeSpecialisation = theme: {
    inheritParentConfig = true;
    configuration = {
      nixy.themeProfile.name = lib.mkForce theme;
    };
  };
in {
  config = lib.mkIf config.nixy.stylix.enable {
    # Generate specialisations for all available themes
    specialisation = lib.listToAttrs (
      map (theme: {
        name = theme;
        value = mkThemeSpecialisation theme;
      })
      availableThemes
    );
  };
}
