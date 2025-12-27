{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vesktop
    sixpair
    appimage-run
    lshw
  ];

  programs.gamemode.enable = true;
  programs.steam.enable = true;
}
