{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    anytype
    vscode
    veracrypt
    zapzap
    speedtest-cli
    kdePackages.gwenview
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
  programs.dconf.enable = true;
}
