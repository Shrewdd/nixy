{ config, pkgs, ... }:

{
  # Minimal shared Flatpak module: enable the service and ensure Flathub
  # is configured. Portal configuration was intentionally removed per request.

  services.flatpak.enable = true;
  # Ensure Flathub remote exists system-wide. This runs once during
  # activation and is safe to keep; machines that don't want Flathub can
  # remove or override this module per-host.
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

}
