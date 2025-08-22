{ config, lib, pkgs, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "dracula-plus"; # custom theme name below
      theme_background = false;      # transparent so terminal theme shows
      vim_keys = true;               # faster navigation
      rounded_corners = true;        # nicer box look
      graph_symbol = "braille";      # dense graphs
      shown_boxes = "proc cpu mem net"; # minimal essential boxes
      update_ms = 1600;              # balanced refresh (lower CPU usage)
      proc_sorting = "cpu";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      mem_graphs = true;
      cpu_graph_upper = "total";
      cpu_invert_lower = false;
      temp_scale = "celsius";
      net_auto = true;
      show_battery = true;
      show_uptime = true;
      check_temp = true;
      use_psutil = false;            # native /proc parsing faster generally
    };

    themes.dracula-plus = ''
      theme[main_bg]="#1e1f29"
      theme[main_fg]="#f8f8f2"
      theme[title]="#f8f8f2"
      theme[hi_fg]="#6272a4"
      theme[selected_bg]="#ff79c6"
      theme[selected_fg]="#f8f8f2"
      theme[inactive_fg]="#44475a"
      theme[graph_text]="#f8f8f2"
      theme[meter_bg]="#44475a"
      theme[proc_misc]="#bd93f9"
      theme[cpu_box]="#bd93f9"
      theme[mem_box]="#50fa7b"
      theme[net_box]="#ff5555"
      theme[proc_box]="#8be9fd"
      theme[div_line]="#44475a"
      theme[temp_start]="#bd93f9"
      theme[temp_mid]="#ff79c6"
      theme[temp_end]="#ff33a8"
      theme[cpu_start]="#bd93f9"
      theme[cpu_mid]="#8be9fd"
      theme[cpu_end]="#50fa7b"
      theme[free_start]="#ffa6d9"
      theme[free_mid]="#ff79c6"
      theme[free_end]="#ff33a8"
      theme[cached_start]="#b1f0fd"
      theme[cached_mid]="#8be9fd"
      theme[cached_end]="#26d7fd"
      theme[available_start]="#ffd4a6"
      theme[available_mid]="#ffb86c"
      theme[available_end]="#ff9c33"
      theme[used_start]="#96faaf"
      theme[used_mid]="#50fa7b"
      theme[used_end]="#0dfa49"
      theme[download_start]="#bd93f9"
      theme[download_mid]="#50fa7b"
      theme[download_end]="#8be9fd"
      theme[upload_start]="#8c42ab"
      theme[upload_mid]="#ff79c6"
      theme[upload_end]="#ff33a8"
      theme[process_start]="#50fa7b"
      theme[process_mid]="#59b690"
      theme[process_end]="#6272a4"
    '';
  };
}
