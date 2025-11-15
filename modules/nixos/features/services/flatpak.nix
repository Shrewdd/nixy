{ config, lib, pkgs, ... }:

{
  options.features.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak support";
  };

  config = lib.mkIf config.features.services.flatpak.enable {
    services.flatpak.enable = true;

    # Add Flathub repository
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
