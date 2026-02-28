{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/stylix/theme-profiles.nix
    ../../modules/profiles/gnome.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.11";

  nixy.stylix.enable = true;
  nixy.themeProfile.name = "rose-pine-dawn";

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    home.stateVersion = "25.11";
  };
}
