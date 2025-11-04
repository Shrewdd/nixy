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
          focus-at-startup = true;
        };
        "HDMI-A-5" = {
          position = { x = 1920; y = 0; };
          scale = 1.0;
          mode = { width = 1920; height = 1080; refresh = 100.0; };
        };
      };

      # ===================================
      # APPLICATION FIXES
      # ===================================
      # Fixes launching and client-side decorations for apps like Spotify and Roblox
      prefer-no-csd = true;

      # ===================================
      # ENVIRONMENT VARIABLES
      # ===================================
      environment."NIXOS_OZONE_WL" = "1";

      # ===================================
      # LAYOUT
      # ===================================
      layout = {
        gaps = 8;
        prefer-no-csd = true;
      };

      # ===================================
      # HOTKEY BINDINGS
      # ===================================
      binds = with config.lib.niri.actions; {
        # Terminal
        "Mod+Return".action = spawn "ghostty";

        # Application launcher
        "Mod+A".action = spawn "fuzzel";

        # Volume controls
        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

        # Show hotkey overlay
        "Mod+Shift+slash".action = show-hotkey-overlay;

        # Window management
        "Mod+Q".action = close-window;
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+L".action = move-column-right;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+L".action = focus-monitor-right;
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Ctrl+Shift+H".action = move-column-to-monitor-left;
        "Mod+Ctrl+Shift+L".action = move-column-to-monitor-right;
        "Mod+Ctrl+Shift+Left".action = move-column-to-monitor-left;
        "Mod+Ctrl+Shift+Right".action = move-column-to-monitor-right;
        "Mod+Ctrl+Shift+Down".action = move-column-to-monitor-down;
        "Mod+Ctrl+Shift+Up".action = move-column-to-monitor-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;
        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+comma".action = consume-or-expel-window-left;
        "Mod+period".action = consume-or-expel-window-right;
        "Mod+bracketleft".action = consume-window-into-column;
        "Mod+bracketright".action = expel-window-from-column;
        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+C".action = center-column;
        "Mod+minus".action = set-column-width "-10%";
        "Mod+equal".action = set-column-width "+10%";
        "Mod+Shift+minus".action = set-window-height "-10%";
        "Mod+Shift+equal".action = set-window-height "+10%";
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+Shift+F".action = toggle-windowed-fullscreen;
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

        # Quit niri
        "Mod+Shift+Q".action = quit;
      };
    };
  };
}