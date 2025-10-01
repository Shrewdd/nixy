{ config, pkgs, ... }:
{
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
    activeConfig = "dashboard"; # directory based config
    configs.dashboard = ./dashboard; # contains shell.qml
    systemd.enable = true;
    systemd.target = "graphical-session.target";
  };
}