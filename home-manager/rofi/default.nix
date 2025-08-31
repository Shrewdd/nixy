{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    location = "center";
    theme = {
      "*" = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        border = 0;
        margin = 0;
        padding = 0;
        spacing = 0;
      };
      "window" = {
        width = "40%";
        border-radius = "8px";
        background = "#1e1e2e";
      };
      "inputbar" = {
        background = "#313244";
        border-radius = "4px";
        margin = "10px";
        padding = "8px";
      };
      "entry" = {
        placeholder = "Search...";
      };
      "listview" = {
        background = "#1e1e2e";
        margin = "10px 0";
        lines = 8;
      };
      "element" = {
        padding = "8px 16px";
        border-radius = "4px";
        margin = "2px 10px";
      };
      "element selected" = {
        background = "#89b4fa";
        foreground = "#1e1e2e";
      };
    };
  };
}
