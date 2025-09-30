{ config, pkgs, ... }:
{
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
    activeConfig = "dashboard"; # directory based config
    configs.dashboard = ./dashboard; # contains shell.qml
  };
}