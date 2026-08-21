{...}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      cursor_shape = "beam";
      cursor_blink_interval = "-1";
      confirm_os_window_close = 0;
      window_padding_width = 5;
      mouse_hide_wait = "3.0";
      cursor_trail = 150;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
    };
  };
}
