{ pkgs, ... }:

{

  #######################
  # SYSTEM PACKAGES
  #######################
  environment.systemPackages = with pkgs; [
    librewolf # browser
    vscode # code editor
    ghostty # terminal
    gnomeExtensions.appindicator # System tray extension
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

  programs.zoom-us = {
    enable = true;
  };


}