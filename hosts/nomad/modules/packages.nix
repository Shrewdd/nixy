{ pkgs, ... }:

{
  # ===================================
  # SYSTEM PACKAGES
  # ===================================
  environment.systemPackages = with pkgs; [
    librewolf                  # browser
    ghostty                    # terminal
  ];

  # ===================================
  # PROGRAMS WITH OPTIONS
  # ===================================
  # programs.localsend, programs.nh and programs.zoom-us are provided
  # by the shared packages module (`shared/nixos/packages.nix`).
  programs.git = {
    enable = true;
  };

}