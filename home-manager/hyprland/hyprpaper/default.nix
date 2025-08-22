{ config, pkgs, ... }:
let
  wallDir = "${config.home.homeDirectory}/nixy/home-manager/hyprland/hyprpaper/wallpapers";
  primaryMon = "desc:Samsung Electric Company LS24C33xG H9TX501846";
  secondaryMon = "desc:Samsung Electric Company LS24C33xG H9TX501795";
  mainWall = "${wallDir}/cutiepatootie.png";
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ mainWall ];
      wallpaper = [
        "${primaryMon},${mainWall}"
        "${secondaryMon},${mainWall}"
      ];
    };
  };
}
