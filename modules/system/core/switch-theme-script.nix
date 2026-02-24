{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.nixy.stylix;
  themes = import ../../shared/stylix/themes.nix;
  themeNames = builtins.attrNames themes;

  # Build script that switches to specified theme using specialisations
  switchThemeScript = pkgs.writeShellScriptBin "switch-theme" ''
        SPECIALISATIONS_DIR="/nix/var/nix/profiles/system/specialisation"
        THEMES=(${lib.concatMapStringsSep " " (t: "\"${t}\"") themeNames})

        # If no argument provided, show interactive menu
        if [[ $# -eq 0 ]]; then
          echo "Select a theme:"
          for i in "''${!THEMES[@]}"; do
            echo "  $((i+1))) ''${THEMES[$i]}"
          done
          echo ""
          read -p "Enter choice [1-''${#THEMES[@]}]: " choice
          if ! [[ "$choice" =~ ^[0-9]+$ ]] || ((choice < 1 || choice > ''${#THEMES[@]})); then
            echo "Invalid selection"
            exit 1
          fi
          THEME="''${THEMES[$((choice-1))]}"
        elif [[ $# -eq 1 ]]; then
          THEME="$1"
        else
          echo "Usage: switch-theme [theme]"
          echo ""
          echo "Available themes:"
          for theme in "''${THEMES[@]}"; do echo "  - $theme"; done
          exit 1
        fi
        SPECIALISATION_PATH="$SPECIALISATIONS_DIR/$THEME"

        if [[ ! -d "$SPECIALISATION_PATH" ]]; then
          echo "Error: Specialisation '$THEME' not found in current system"
          echo ""
          echo "Available specialisations:"
          ls -1 "$SPECIALISATIONS_DIR" 2>/dev/null | sed 's/^/  /'
          echo ""
          echo "To use this theme, you may need to:"
          echo "  1. Rebuild with: sudo nixos-rebuild switch --flake .#$(hostname)"
          echo "  2. Then try: switch-theme $THEME"
          exit 1
        fi

        # Map theme to polarity
        declare -A THEME_POLARITY=(
    ${lib.concatMapStringsSep "\n      " (name: "      [${name}]=\"${themes.${name}.polarity}\"") themeNames}
        )
        POLARITY="''${THEME_POLARITY[$THEME]:-dark}"

        # Map theme to wallpaper path
        declare -A THEME_WALLPAPER=(
      ${lib.concatMapStringsSep "\n      " (name: "      [${name}]=\"${themes.${name}.wallpaper}\"") themeNames}
        )
        WALLPAPER="''${THEME_WALLPAPER[$THEME]:-}"

        echo "Switching to theme: $THEME"

        # Activate the specialisation
        sudo "$SPECIALISATION_PATH/bin/switch-to-configuration" switch

        # Reload Caelestia so it picks updated HM settings (including wallpaperDir)
        if command -v systemctl &> /dev/null; then
          systemctl --user restart caelestia.service &>/dev/null || true
          sleep 1
        fi

        # Apply runtime theme changes
        if command -v caelestia &> /dev/null; then
          caelestia scheme set -m "$POLARITY" &>/dev/null || true
          if [[ -n "$WALLPAPER" ]]; then
            caelestia wallpaper -f "$WALLPAPER" &>/dev/null || true
          fi
        fi

        if command -v gsettings &> /dev/null; then
          if [[ "$POLARITY" == "dark" ]]; then
            gsettings set org.gnome.desktop.interface color-scheme prefer-dark &>/dev/null || true
          else
            gsettings set org.gnome.desktop.interface color-scheme prefer-light &>/dev/null || true
          fi
        fi

        echo "✓ Theme switched to $THEME"
  '';
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [switchThemeScript];
  };
}
