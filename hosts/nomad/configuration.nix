{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/profiles/laptop.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.11";

  nixy.themeProfile.name = "catppuccin-latte";

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    imports = [../../modules/user/profiles/desktop.nix];
  };
}
