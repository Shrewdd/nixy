{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/profiles/laptop.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.05";

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    imports = [../../modules/user/profiles/desktop.nix];

    # Host-specific packages
    home.packages = with pkgs; [tree];
  };
}
