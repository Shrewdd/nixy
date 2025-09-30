{ pkgs, lib, ... }:
let
  theme = import ../../shared/theme/everforest.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # ===================================
      # VARIABLE DEFINITIONS
      # ===================================
      # Main modifier key for most shortcuts
      "$mainMod" = "SUPER";
      # Default applications for various operations
      "$terminal" = "ghostty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun";

      # ===================================
      # STARTUP APPLICATIONS
      # ===================================
      # Applications to run automatically when Hyprland starts
      "exec-once" = [
        "systemctl --user start hyprpolkitagent"  # Polkit authentication agent
        "waybar"                                   # Status bar
        "quickshell"                              # QuickShell dashboard
      ];

      # ===================================
      # MONITOR CONFIGURATION
      # ===================================
      # Dual monitor setup with Samsung displays at 100Hz
      monitor = [
        "desc:Samsung Electric Company LS24C33xG H9TX501846, 1920x1080@100, 0x0, 1"
        "desc:Samsung Electric Company LS24C33xG H9TX501795, 1920x1080@100, 1920x0, 1"
      ];

      # ===================================
      # GENERAL APPEARANCE & LAYOUT
      # ===================================
      general = {
        layout = "dwindle";           # Window layout algorithm
        border_size = 3;              # Border thickness in pixels
        # Active window border: gradient from green to teal (Everforest nature theme)
        "col.active_border" = "${theme.rgb.green} ${theme.rgb.teal} 135deg";
        # Inactive window border: surface color
        "col.inactive_border" = theme.rgb.surface1;
        gaps_in = 2;                  # Inner gaps between windows
        gaps_out = 8;                 # Outer gaps around screen edges
      };

      # ===================================
      # DWINDLE LAYOUT SETTINGS
      # ===================================
      dwindle = {
        preserve_split = true;        # Makes togglesplit work.
      };

      # ===================================
      # WINDOW GROUPING
      # ===================================
      # Configuration for grouped windows (tabbed containers)
      group = {
        # Active group border: gradient from blue to sky (cool forest colors)
        "col.border_active" = "${theme.rgb.blue} ${theme.rgb.sky} 135deg";
        "col.border_inactive" = theme.rgb.surface1;
        # Locked group border: gradient from yellow to peach (warm forest colors)
        "col.border_locked_active" = "${theme.rgb.yellow} ${theme.rgb.peach} 135deg";
        "col.border_locked_inactive" = theme.rgb.surface1;
        groupbar = {
          font_size = 11;             # Font size for group titles
          gradients = false;          # Disable gradient backgrounds in group bar
        };
      };

      # ===================================
      # VISUAL EFFECTS & DECORATION
      # ===================================
      decoration = {
        rounding = 10;                # Corner radius for windows
        
        # Blur settings for transparency effects
        blur = {
          enabled = true;             # Enable blur behind transparent windows
          size = 3;                   # Blur radius
          passes = 1;                 # Number of blur passes (higher = more intense)
          new_optimizations = true;   # Use newer blur algorithms for better performance
        };
        
        # Drop shadow configuration
        shadow = {
          enabled = true;             # Enable window shadows
          range = 4;                  # Shadow blur radius
          render_power = 3;           # Shadow rendering intensity
          # Semi-transparent dark shadow for active windows
          color = "rgba(1a1a1a80)";
          # Lighter shadow for inactive windows
          color_inactive = "rgba(00000060)";
        };
      };

      # ===================================
      # KEYBINDINGS - BASIC ACTIONS
      # ===================================
      bind = [
        # Application launchers
        "$mainMod, RETURN, exec, $terminal"                                               # Terminal
        "$mainMod, E, exec, $fileManager"                                                # File manager
        "$mainMod, A, exec, $menu"                                                       # Application launcher
        "$mainMod, X, exec, bash /home/km/nixy/home-manager/rofi/scripts/powermenu/powermenu"  # Power menu
        
        # Window management
        "$mainMod, Q, killactive,"                                                       # Close active window
        "$mainMod, M, exit,"                                                             # Exit Hyprland
        "$mainMod, V, togglefloating,"                                                   # Toggle floating mode
        "$mainMod, P, pseudo"                                                            # Pseudo-tile mode
        "$mainMod, J, togglesplit"                                                       # Toggle split direction
        
        # Focus movement using arrow keys
        "$mainMod, left, movefocus, l"                                                   # Focus left
        "$mainMod, right, movefocus, r"                                                  # Focus right
        "$mainMod, up, movefocus, u"                                                     # Focus up
        "$mainMod, down, movefocus, d"                                                   # Focus down
        
        # Workspace switching (1-10)
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move windows to workspaces (1-10)
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"                                     # Toggle special workspace
        

        "$mainMod SHIFT, S, movetoworkspace, special:magic"                              # Move to special workspace
        
        # Mouse wheel workspace switching
        "$mainMod, mouse_down, workspace, e+1"                                           # Next workspace
        "$mainMod, mouse_up, workspace, e-1"                                             # Previous workspace
        
        # Wallpaper changer
        "$mainMod, W, exec, bash /home/km/nixy/home-manager/hyprland/hyprpaper/change-wallpaper.sh"
        
        # Screenshot functionality
        "$mainMod, Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save screen --freeze \"$f\" && wl-copy < \"$f\" && notify-send -i \"$f\" \"Screenshot Saved\" \"$f\"'"  # Full screen
        ", Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save area --freeze \"$f\" && wl-copy < \"$f\" && notify-send -i \"$f\" \"Screenshot Saved\" \"$f\"'"         # Area selection
      ];

      # ===================================
      # MOUSE BINDINGS
      # ===================================
      # Mouse actions while holding the main modifier
      bindm = [
        "$mainMod, mouse:272, movewindow"    # Left click: move window
        "$mainMod, mouse:273, resizewindow"  # Right click: resize window
      ];

      # ===================================
      # MEDIA & VOLUME CONTROLS
      # ===================================
      # Volume controls with progress bar notifications
      bindel = [
        # Volume up: increase by 5% with notification
        ",XF86AudioRaiseVolume, exec, bash -c 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol -a \"Volume\" \"Volume: $vol%\"'"
        # Volume down: decrease by 5% with notification
        ",XF86AudioLowerVolume, exec, bash -c 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol -a \"Volume\" \"Volume: $vol%\"'"
        # Volume mute: toggle mute state with notification
        ",XF86AudioMute, exec, bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@) && if echo \"$vol_info\" | grep -q MUTED; then notify-send -r 9991 -h int:value:0 -a \"Volume\" \"Volume: Muted\"; else vol_num=$(echo \"$vol_info\" | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol_num -a \"Volume\" \"Volume: $vol_num%\"; fi'"
        # Microphone mute: toggle microphone mute state
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      # Media playback controls
      bindl = [
        ", XF86AudioNext, exec, playerctl next"        # Next track
        ", XF86AudioPause, exec, playerctl play-pause" # Pause/unpause
        ", XF86AudioPlay, exec, playerctl play-pause"  # Play/pause
        ", XF86AudioPrev, exec, playerctl previous"    # Previous track
      ];

      # Key release bindings
      bindr = [
        # QuickShell dashboard toggle on Super key release
        "$mainMod, SUPER_L, exec, bash -c 'qs -c dashboard ipc call dashboard toggle'"  # Toggle dashboard with Super release
      ];

      # ===================================
      # WINDOW RULES - BASIC
      # ===================================
      # General window behavior rules
      windowrule = [
        # Prevent maximization for all windows (maintains tiling behavior)
        "suppressevent maximize, class:.*"
        # Ignore empty XWayland windows that sometimes appear
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        
        # Application-specific border colors using Everforest theme
        "bordercolor ${theme.rgb.blue}, class:(.*zen.*)"        # Zen Browser: blue
        "bordercolor ${theme.rgb.green}, class:(code)"          # VS Code: green
        "bordercolor ${theme.rgb.yellow}, class:(.*ghostty.*)"  # Ghostty terminal: yellow
        "bordercolor ${theme.rgb.mauve}, class:(.*vesktop.*)"   # Vesktop: mauve
        "bordercolor ${theme.rgb.teal}, class:(.*spotify.*)"    # Spotify: teal
      ];

      # ===================================
      # WINDOW RULES - ADVANCED
      # ===================================
      # More specific window rules with additional properties
      windowrulev2 = [
        # Additional application border colors
        "bordercolor ${theme.rgb.red}, class:(.*steam.*)"      # Steam: red
        "bordercolor ${theme.rgb.peach}, class:(.*thunar.*)"   # Thunar: peach
        
        # Opacity settings for different window types
        "opacity 0.9 0.9, class:(.*terminal.*)"              # Slightly transparent terminals
        "opacity 0.95 0.95, class:(.*)"                      # Subtle transparency for all windows
      ];

      # ===================================
      # MISCELLANEOUS SETTINGS
      # ===================================
      misc = {
        # Disable default Hyprland branding and wallpapers
        force_default_wallpaper = 0;   # Don't force default wallpaper
        disable_hyprland_logo = true;  # Hide Hyprland logo on empty workspaces
        disable_splash_rendering = true; # Disable startup splash screen
        
        # Power management integration
        mouse_move_enables_dpms = true; # Wake displays on mouse movement
        key_press_enables_dpms = true;  # Wake displays on key press
      };
    };
  };
}