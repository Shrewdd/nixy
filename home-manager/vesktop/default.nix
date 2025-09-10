{ config, pkgs, inputs, ... }:
let
  theme = import ../../themes/catppuccin-macchiato.nix;
in
{
  programs.vesktop = {
    enable = true;

    # Use latest Vesktop package
    package = pkgs.vesktop;

    # Vesktop-specific settings
    settings = {
      discordBranch = "stable";
      minimizeToTray = true;
      arRPC = true; # Rich presence
      splashTheming = true;
      checkUpdates = false;
    };

    # Vencord settings (the mod that makes Discord better)
    vencord = {
      enable = true;

      # Use system-wide Vencord installation
      useSystem = true;

      # Vencord settings
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
      };

      # Official Catppuccin theme
      themes = {
        catppuccin-macchiato = {
          name = "Catppuccin Macchiato";
          url = "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css";
        };
      };

      # All your extensions/plugins go here instead of cloud sync
      settings.plugins = {
        # Add all your plugins here
        # Example:
        # hideDisabledEmojis.enable = true;
        # favoriteEmojiFirst.enable = true;
        # etc.
      };
    };
  };
}
