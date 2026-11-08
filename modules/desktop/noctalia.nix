# ── Noctalia shell ───────────────────────────────────────────────────────
{...}: {
  # ════════════════════════════════════════════════════════════════════════
  # ── NixOS ──────────────────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  # ── Display Manager ──────────────────────────────────────────────────
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = ["km"];
    settings.keyboard.layout = "pl";
  };

  # ════════════════════════════════════════════════════════════════════════
  # ── Home Manager (km) ──────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  # ── Noctalia shell ─────────────────────────────────────────────────
  home-manager.users.km.programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      shell.launcher.categories = false;
      shell.launch_apps_as_systemd_services = true;
      shell.polkit_agent = true;
      shell.greeter_sync.auto_sync = true;
      location.auto_locate = true;
      shell.screenshot = {
        show_cursor = true;
        annotate = true;
      };
      shell.screen_corners = {
        enabled = true;
        size = 32;
      };
    };
  };
}
