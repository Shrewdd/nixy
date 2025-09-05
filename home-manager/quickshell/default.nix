{ config, pkgs, ... }:

{
  programs.quickshell = {
    enable = true;
    configs = {
      default = ./shell.qml;
    };
    activeConfig = "default";
  };
}
