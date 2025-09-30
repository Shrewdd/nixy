{ config, pkgs, ... }:
{
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
    activeConfig = "dashboard";
    configs.dashboard = ./shell.qml;
  };

  programs.waybar.enable = false;
}