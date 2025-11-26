{ config, lib, pkgs, ... }:

{
  options.hm.apps.ghostty = {
    enable = lib.mkEnableOption "Ghostty terminal emulator";
    
    theme = lib.mkOption {
      type = lib.types.str;
      default = "Everforest Dark Hard";
      description = "Ghostty color theme";
    };

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono NF";
      description = "Font family for Ghostty";
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 14;
      description = "Font size";
    };
  };

  config = lib.mkIf config.hm.apps.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      
      settings = {
        theme = config.hm.apps.ghostty.theme;
        background-blur-radius = 20;
        font-family = config.hm.apps.ghostty.fontFamily;
        font-feature = [ "+ss02" "+ss03" "+ss05" "+ss07" ];
        font-size = config.hm.apps.ghostty.fontSize;
        adjust-cell-height = "28%";
        cursor-style = "bar";
        cursor-style-blink = true;
        cursor-invert-fg-bg = false;
        gtk-single-instance = true;
        window-theme = "system";
        gtk-titlebar = true;
        gtk-wide-tabs = false;
        macos-titlebar-style = "hidden";
        macos-option-as-alt = true;
        mouse-hide-while-typing = true;
        confirm-close-surface = false;
        window-padding-x = "4,5";
        window-padding-y = "4,5";
        window-padding-balance = true;
        auto-update = "check";
        auto-update-channel = "stable";
        shell-integration-features = "no-cursor,no-sudo,no-title";
        
        # Use xterm-256color for SSH compatibility (servers don't know xterm-ghostty)
        term = "xterm-256color";
      };
    };
  };
}
