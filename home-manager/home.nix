{ pkgs, ... }:
{
  # User-installed applications handled by Home Manager
  home.packages = with pkgs; [
    veracrypt
    playerctl
    vscode
    hyprpolkitagent

  ];
}
