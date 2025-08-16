{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Fira Sans 10";
        frame_color = "#a78bfa";
        separator_color = "frame";
        background = "#181825";
        foreground = "#cdd6f4";
        width = 300;
        height = 80;
        offset = "20x20";
        transparency = 10;
        corner_radius = 8;
        padding = 16;
        horizontal_padding = 16;
        frame_width = 2;
        gap_size = 8;
        monitor = 0;
        follow = "mouse";
        sort = true;
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        geometry = "300x80-20+20";
      };
      urgency_low = {
        background = "#181825";
        foreground = "#cdd6f4";
        frame_color = "#a6e3a1";
        timeout = 3;
      };
      urgency_normal = {
        background = "#181825";
        foreground = "#cdd6f4";
        frame_color = "#a78bfa";
        timeout = 6;
      };
      urgency_critical = {
        background = "#181825";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";
        timeout = 10;
      };
    };
  };
}
