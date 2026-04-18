{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/stylix/theme-profiles.nix
    ../../modules/profiles/gnome.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.11";

  nixy.themeProfile.name = "rose-pine-dawn";

  # ── Home Manager ───────────────────────────────────────────────────
  home-manager.users.km = {
    home.stateVersion = "25.11";
  };
}
