{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.nixy.stylix;
  themeNames = [
    "catppuccin-latte"
    "catppuccin-mocha"
    "rose-pine-moon"
    "rose-pine-dawn"
  ];

  # Build script that switches to specified theme using specialisations
  switchThemeScript = pkgs.writeShellScriptBin "switch-theme" ''
    SPECIALISATIONS_DIR="/nix/var/nix/profiles/system/specialisation"

    if [[ $# -ne 1 ]]; then
      echo "Usage: switch-theme <theme>"
      echo ""
      echo "Available themes:"
      ${lib.concatMapStringsSep "\n      " (theme: "echo '  - ${theme}'") themeNames}
      echo ""
      echo "Currently available specialisations:"
      ls -1 "$SPECIALISATIONS_DIR" 2>/dev/null | sed 's/^/  /'
      exit 1
    fi

    THEME="$1"
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
      [catppuccin-latte]="light"
      [catppuccin-mocha]="dark"
      [rose-pine-moon]="dark"
      [rose-pine-dawn]="light"
    )
    POLARITY="''${THEME_POLARITY[$THEME]:-dark}"

    echo "Switching to theme: $THEME"

    # Activate the specialisation
    sudo "$SPECIALISATION_PATH/bin/switch-to-configuration" switch

    # Apply runtime theme changes
    if command -v caelestia &> /dev/null; then
      caelestia scheme set -m "$POLARITY" &>/dev/null || true
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
