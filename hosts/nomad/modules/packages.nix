{ pkgs, ... }:

{

  #######################
  # SYSTEM PACKAGES
  #######################
  environment.systemPackages = with pkgs; [
    librewolf
    vscode
    ghostty
  ];

  #######################
  # PROGRAMS
  #######################
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.git = {
    enable = true;
  };

}