{ config, lib, ... }:

{
  # ===================================
  # NIRI SCROLLING MANAGER
  # ===================================

  programs.niri = {
    settings = {
      # ===================================
      # DISPLAY CONFIGURATION
      # ===================================
      outputs = {
        "HDMI-A-4" = {
          position = { x = 0; y = 0; };
          scale = 1.0;
          mode = { width = 1920; height = 1080; refresh = 100.0; };
        };
        "HDMI-A-5" = {
          position = { x = 1920; y = 0; };
          scale = 1.0;
          mode = { width = 1920; height = 1080; refresh = 100.0; };
        };
      };

      # ===================================
      # ENVIRONMENT VARIABLES
      # ===================================
      environment."NIXOS_OZONE_WL" = "1";

      # ===================================
      # HOTKEY BINDINGS
      # ===================================
      binds = with config.lib.niri.actions; {
        # Terminal
        "Mod+Return".action = spawn "ghostty";

        # Application launcher
        "Mod+A".action = spawn "fuzzel";

        # Window management
        "Mod+Q".action = close-window;

        # Quit niri
        "Mod+Shift+Q".action = quit;
      };
    };
  };
}