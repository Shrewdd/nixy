{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vesktop
    sixpair
    appimage-run
    lshw
    speedtest-cli
  ];

  programs.gamemode.enable = true;
}
