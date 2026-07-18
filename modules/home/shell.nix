{
  pkgs,
  lib,
  ...
}: {
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

  # ── Shell utilities ────────────────────────────────────────────────
  home.packages = with pkgs; [fd rbw pinentry-curses];

  # ── Btop ───────────────────────────────────────────────────────────
  programs.btop = {
    enable = true;
    settings = {
      color_theme = lib.mkDefault "Default";
      theme_background = false;
    };
  };

  # ── SSH auth ───────────────────────────────────────────────────────
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
  };
}
