{ pkgs, ... }:
let
  theme = import ../../shared/theme/macchiato.nix;
in
{
  services.dunst = {
    enable = true;
    settings = {
      # ===================================
      # GLOBAL NOTIFICATION SETTINGS
      # ===================================
      global = {
        # Appearance and styling
        font = "Fira Sans Medium 11";              # Font family and size
        frame_color = "${theme.rgb.mauve}";        # Border color using theme
        separator_color = "auto";                  # Automatic separator color
        background = "#24273aE6";                # Semi-transparent background
        foreground = "${theme.rgb.text}";          # Text color from theme
        
        # Size and positioning
        width = "(250, 350)";                      # Dynamic width range
        height = 80;                               # Fixed notification height
        offset = "20x50";                          # Position from top-right corner
        origin = "top-right";                      # Anchor point for positioning
        corner_radius = 10;                        # Rounded corner radius
        
        # Spacing and padding
        padding = 16;                              # Internal padding
        horizontal_padding = 20;                   # Horizontal padding
        text_icon_padding = 12;                    # Space between icon and text
        frame_width = 2;                           # Border thickness
        gap_size = 8;                              # Gap between multiple notifications
        
        # Behavior settings
        monitor = 0;                               # Display on primary monitor
        follow = "mouse";                          # Follow mouse cursor
        sort = true;                               # Sort notifications by urgency
        idle_threshold = 120;                      # Hide after idle time (seconds)
        show_age_threshold = 60;                   # Show age after threshold
        
        # Text formatting
        line_height = 4;                           # Line spacing
        markup = "full";                           # Enable markup formatting
        format = "<b>%s</b>\\n<span size='small' alpha='80%'>%b</span>";  # Title and body format
        alignment = "left";                        # Text alignment
        vertical_alignment = "center";             # Vertical text alignment
        word_wrap = true;                          # Enable word wrapping
        ignore_newline = false;                    # Preserve line breaks
        
        # Icon settings
        icon_position = "left";                    # Icon position
        max_icon_size = 32;                        # Maximum icon size
        icon_theme = "Papirus-Dark";               # Icon theme
        enable_recursive_icon_lookup = true;       # Enhanced icon searching
        
        # Mouse interaction
        mouse_left_click = "close_current";       # Left click action
        mouse_middle_click = "do_action";          # Middle click action
        mouse_right_click = "close_all";           # Right click action
        
        # Advanced features
        notification_limit = 5;                   # Maximum visible notifications
        indicate_hidden = true;                    # Show hidden notification indicator
        transparency = 8;                          # Global transparency level
        separator_height = 2;                      # Separator line thickness
        always_run_script = true;                  # Always execute notification scripts
        title = "Dunst";                          # Window title
        class = "Dunst";                           # Window class
        
        # Progress bar styling
        progress_bar = true;                       # Enable progress bars
        progress_bar_height = 4;                   # Progress bar thickness
        progress_bar_frame_width = 0;              # No frame around progress bar
        progress_bar_min_width = 150;              # Minimum progress bar width
        progress_bar_max_width = 300;              # Maximum progress bar width
      };
      
      # ===================================
      # URGENCY LEVEL CONFIGURATIONS
      # ===================================
      # Low urgency notifications (info, success)
      urgency_low = {
        background = "#24273aE6";                  # Semi-transparent background
        foreground = "${theme.rgb.subtext1}";      # Muted text color
        frame_color = "${theme.rgb.green}";        # Green border for low urgency
        timeout = 4;                               # Auto-dismiss timeout
        default_icon = "dialog-information";       # Default icon
      };
      
      # Normal urgency notifications (default)
      urgency_normal = {
        background = "#24273aE6";                  # Semi-transparent background
        foreground = "${theme.rgb.text}";          # Normal text color
        frame_color = "${theme.rgb.blue}";         # Blue border for normal urgency
        timeout = 8;                               # Standard timeout
        default_icon = "dialog-information";       # Default icon
      };
      
      # Critical urgency notifications (errors, warnings)
      urgency_critical = {
        background = "#ed87961A";                  # Subtle red-tinted background
        foreground = "${theme.rgb.text}";          # High contrast text
        frame_color = "${theme.rgb.red}";          # Red border for critical urgency
        timeout = 0;                               # Never auto-dismiss
        default_icon = "dialog-error";             # Error icon
        format = "<b><u>URGENT</u></b>\\n<b>%s</b>\\n%b";  # Special urgent formatting
      };
      
      # ===================================
      # APPLICATION-SPECIFIC RULES
      # ===================================
      # Volume notifications with centered display and progress bar
      volume = {
        appname = "Volume";                        # Match volume notifications
        urgency = "low";                           # Low urgency level
        timeout = 2;                               # Quick dismissal
        format = "<b>%s</b>";                      # Simple format: just the volume text
        frame_color = "${theme.rgb.teal}";         # Teal border for volume
        background = "#24273aF0";                  # More opaque for visibility
        foreground = "${theme.rgb.text}";          # Standard text color
        icon_position = "off";                     # No icon for cleaner appearance
        width = 350;                               # Fixed width for consistency
        height = 80;                               # Compact height
        horizontal_padding = 24;                   # Generous horizontal padding
        padding = 16;                              # Internal padding
        corner_radius = 15;                        # More rounded corners
        offset = "0x0";                            # Perfect center positioning
        origin = "center";                         # Center anchor point
        alignment = "center";                      # Center text alignment
        progress_bar = true;                       # Enable volume progress bar
        progress_bar_height = 6;                   # Progress bar thickness
        progress_bar_frame_width = 0;              # Clean progress bar
        progress_bar_min_width = 300;              # Progress bar width
        progress_bar_max_width = 300;              # Fixed progress bar width
      };
      
      # Screenshot notifications with preview support
      screenshot = {
        appname = "Screenshot*";                   # Match screenshot notifications
        urgency = "low";                           # Low urgency level
        timeout = 5;                               # Longer timeout for file operations
        frame_color = "${theme.rgb.lavender}";     # Lavender border for screenshots
        format = "<b>%s</b>\\n%b";                 # Standard title and body format
      };
      
      # Media player notifications
      media = {
        appname = "Spotify";                       # Match Spotify notifications
        urgency = "low";                           # Low urgency level
        timeout = 3;                               # Quick dismissal
        frame_color = "${theme.rgb.green}";        # Green border for media
        format = "<b>♫ %s</b>\\n%b";               # Music note prefix
      };
    };
  };
}
