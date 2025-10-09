{ pkgs, ... }:

{

  #######################
  # SYSTEM PACKAGES
  #######################
  environment.systemPackages = with pkgs; [
    librewolf # browser
    vscode # code editor
    ghostty # terminal
  
  # GNOME EXTENSIONS!
  gnomeExtensions.appindicator; # GNOME tray extension for system tray icons
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