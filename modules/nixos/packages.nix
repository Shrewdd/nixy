{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    nixd
    alejandra
    apostrophe
    anytype
    vscode
    zapzap
    speedtest-cli
    gthumb
    tree
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
