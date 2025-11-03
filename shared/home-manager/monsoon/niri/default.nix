{ config, lib, ... }:

{
  # ===================================
  # NIRI SCROLLING MANAGER
  # ===================================

  programs.niri = {
    settings = {
      # ===================================
      # HOTKEY BINDINGS
      # ===================================
      binds = with config.lib.niri.actions; {
        # Terminal
        "Mod+Return".action = spawn "ghostty";

        # Window management
        "Mod+Q".action = close-window;
      };
    };
  };
}