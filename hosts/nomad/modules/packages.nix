{ pkgs, ... }:

{

  #######################
  # SYSTEM PACKAGES
  #######################
  environment.systemPackages = with pkgs; [
  librewolf; # privacy-focused browser
  vscode; # code editor
  ghostty; # terminal emulator
  
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