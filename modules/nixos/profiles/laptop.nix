{ config, lib, pkgs, ... }:

{
  # Laptop profile - Desktop features (including GNOME) + laptop-specific settings
  imports = [
    ./desktop.nix
  ];

  # Laptop power management
  services.thermald.enable = lib.mkDefault true;
  services.tlp = {
    enable = lib.mkDefault true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Enable laptop touchpad support
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

  # Backlight control
  programs.light.enable = true;
}
