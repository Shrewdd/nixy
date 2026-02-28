{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/laptop.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.11";

  nixy.themeProfile.name = "rose-pine-dawn";

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    home.stateVersion = "25.11";
  };
}
