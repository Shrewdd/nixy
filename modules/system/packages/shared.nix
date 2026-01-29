{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    apostrophe
    anytype
    vscode
    zapzap
    speedtest-cli
    gthumb
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.nh = {
    enable = true;
    flake = "/home/km/nixy";
  };

  programs.zoom-us.enable = true;
}
