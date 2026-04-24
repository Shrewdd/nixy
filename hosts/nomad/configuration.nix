{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/hypr-nomad.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.11";

  # ── Home Manager ───────────────────────────────────────────────────
  home-manager.users.km = {
    home.stateVersion = "25.11";
  };
}
