{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/kde.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.11";

  hardware.graphics.enable = true;

  # ── Home Manager ───────────────────────────────────────────────────
  home-manager.users.km = {
    home.stateVersion = "25.11";
  };
}
