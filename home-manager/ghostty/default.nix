{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Everforest Dark Hard";
      background-blur-radius = 20;
      font-family = "Maple Mono NF";
      font-feature = [ "+ss02" "+ss03" "+ss05" "+ss07" ];
      font-size = 14;
      adjust-cell-height = "28%";
      cursor-style = "bar";
      cursor-style-blink = true;
      cursor-invert-fg-bg = false;
      gtk-single-instance = true;
      window-theme = "system";
      gtk-titlebar = false;
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
      shell-integration = "fish";
    };
  };
}
