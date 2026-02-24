{
  lib,
  config,
  ...
}: let
  themes = import ../../shared/stylix/themes.nix;
  availableThemes = builtins.attrNames themes;

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
