{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland/default.nix
    ./hyprland/hyprpaper/default.nix
    ./waybar/default.nix
    ./zen-browser/default.nix
    ./git/default.nix
    ./spicetify-nix/default.nix
    ./dunst/default.nix
    ./shell/btop/default.nix
    ./anytype/default.nix
    ./rofi/default.nix
    ./ghostty/default.nix
    ./shell/fish/default.nix
    ./shell/fastfetch/default.nix
    ./shell/starship/default.nix
  ];

  home.username = "km";
  home.homeDirectory = "/home/km";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    vesktop
    vscode
    hyprpolkitagent
  ];

  programs.home-manager.enable = true;
}
