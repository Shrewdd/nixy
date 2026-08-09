{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/hyprland.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "26.05";

  hardware.graphics.enable = true;

  # ── Home Manager ───────────────────────────────────────────────────
  home-manager.users.km = {
    home.stateVersion = "26.05";
  };
}
