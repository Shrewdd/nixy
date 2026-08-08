{lib, ...}: {
  # ── Fish ───────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  # ── Starship ───────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    presets = ["plain-text-symbols"];
  };

  # ── Btop ───────────────────────────────────────────────────────────
  programs.btop = {
    enable = true;
    settings = {
      color_theme = lib.mkDefault "Default";
      theme_background = false;
    };
  };
}
