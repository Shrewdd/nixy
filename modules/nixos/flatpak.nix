{pkgs, ...}: {
  # ── Flatpak runtime ───────────────────────────────────────────────
  services.flatpak.enable = true;

  # ── Flathub remote ────────────────────────────────────────────────
  # Ensure flathub exists on boot for fresh installs.
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
