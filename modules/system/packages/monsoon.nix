{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vesktop
    lutris
    sixpair
    appimage-run
    lshw
    speedtest-cli
    rojo
    wally
    selene
    luau-lsp
    stylua
  ];

  programs.gamemode.enable = true;
  programs.steam.enable = true;
}
