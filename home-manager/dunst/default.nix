{ pkgs, ... }:
let
  theme = import ../../shared/theme/everforest.nix;
in
{
  services.dunst = {
    enable = true;
    settings = {
      # ===================================
      # GLOBAL NOTIFICATION SETTINGS
      # ===================================
      global = {
        # Display
        monitor = 0;
        follow = "mouse";
        
        # Geometry
        width = 350;
        height = 300;
        origin = "top-right";
        offset = "20x50";
        scale = 0;
        notification_limit = 5;
        indicate_hidden = true;
        
        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        # Appearance
        transparency = 5;
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 8;
        frame_width = 2;
        frame_color = "#${theme.surface1}";
        separator_color = "frame";
        corner_radius = 8;
        gap_size = 8;
        
        # Text
        font = "SF Pro Display 11";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        word_wrap = true;
        
        # Icons
        enable_recursive_icon_lookup = true;
        icon_theme = "Adwaita";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 48;
        icon_path = "/usr/share/icons/Adwaita/16x16/status/:/usr/share/icons/Adwaita/16x16/devices/";
        
        # History
        sticky_history = "yes";
        history_length = 20;
        
        # Behavior
        sort = true;
        idle_threshold = 120;
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        ignore_dbusclose = false;
        
        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      
      # ===================================
      # URGENCY LEVEL CONFIGURATIONS
      # ===================================
      # Low urgency notifications (info, success)
      urgency_low = {
        background = "#${theme.base}E6";
        foreground = "#${theme.subtext1}";
        frame_color = "#${theme.green}";
        timeout = 4;
        default_icon = "dialog-information";
      };
      
      # Normal urgency notifications (default)
      urgency_normal = {
        background = "#${theme.base}E6";
        foreground = "#${theme.text}";
        frame_color = "#${theme.blue}";
        timeout = 8;
        default_icon = "dialog-information";
      };
      
      # Critical urgency notifications (errors, warnings)
      urgency_critical = {
        background = "#${theme.base}F0";
        foreground = "#${theme.text}";
        frame_color = "#${theme.red}";
        timeout = 0;
        default_icon = "dialog-error";
        format = "<b><u>URGENT</u></b>\n<b>%s</b>\n%b";
      };
      
      # ===================================
      # APPLICATION-SPECIFIC RULES
      # ===================================
      # Volume notifications
      volume = {
        appname = "Volume";
        urgency = "low";
        timeout = 2;
        format = "<b>%s</b>";
        frame_color = "#${theme.teal}";
        background = "#${theme.base}F0";
        foreground = "#${theme.text}";
        icon_position = "off";
        width = 350;
        height = 80;
        horizontal_padding = 24;
        padding = 16;
        corner_radius = 15;
        offset = "0x0";
        origin = "center";
        alignment = "center";
        progress_bar = true;
        progress_bar_height = 6;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 300;
        progress_bar_max_width = 300;
      };
      
      # Screenshot notifications
      screenshot = {
        appname = "Screenshot*";
        urgency = "low";
        timeout = 5;
        frame_color = "#${theme.lavender}";
        format = "<b>%s</b>\n%b";
      };
      
      # Media player notifications
      media = {
        appname = "Spotify";
        urgency = "low";
        timeout = 3;
        frame_color = "#${theme.green}";
        format = "<b>♫ %s</b>\n%b";
      };
    };
  };
}
