{lib, ...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      background-blur-radius = lib.mkDefault 20;
      font-family = lib.mkDefault "Maple Mono NF";
      font-feature = ["+ss02" "+ss03" "+ss05" "+ss07"];
      font-size = lib.mkDefault 14;
      adjust-cell-height = lib.mkDefault "28%";
      cursor-style = lib.mkDefault "bar";
      cursor-style-blink = lib.mkDefault true;
      cursor-invert-fg-bg = lib.mkDefault false;
      gtk-single-instance = lib.mkDefault true;
      window-theme = lib.mkDefault "system";
      gtk-titlebar = lib.mkDefault true;
      gtk-wide-tabs = lib.mkDefault false;
      macos-titlebar-style = lib.mkDefault "hidden";
      macos-option-as-alt = lib.mkDefault true;
      mouse-hide-while-typing = lib.mkDefault true;
      confirm-close-surface = lib.mkDefault false;
      window-padding-x = lib.mkDefault "4,5";
      window-padding-y = lib.mkDefault "4,5";
      window-padding-balance = lib.mkDefault true;
      auto-update = lib.mkDefault "check";
      auto-update-channel = lib.mkDefault "stable";
      shell-integration-features = lib.mkDefault "no-cursor,sudo,no-title,ssh-env,ssh-terminfo";
      term = lib.mkDefault "xterm-256color";
    };
  };
}
