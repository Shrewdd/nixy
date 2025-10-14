{ config, pkgs, inputs, ... }:

{
  imports = [
    ./../../home-manager/hyprland/default.nix
    ./../../home-manager/hyprland/hyprpaper/default.nix
    ./../../home-manager/zen-browser/default.nix
    ./../../home-manager/git/default.nix
    ./../../home-manager/spotify/default.nix
    ./../../home-manager/dunst/default.nix
    ./../../home-manager/shell/btop/default.nix
    ./../../home-manager/anytype/default.nix
    ./../../home-manager/rofi/default.nix
    ./../../home-manager/ghostty/default.nix
    ./../../home-manager/shell/fish/default.nix
    ./../../home-manager/shell/fastfetch/default.nix
    ./../../home-manager/shell/starship/default.nix
    ./../../home-manager/gtk/default.nix
    ./../../home-manager/waybar/default.nix
  ];

  home.username = "km";
  home.homeDirectory = "/home/km";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    vesktop
    vscode
  ];

  programs.home-manager.enable = true;
}
