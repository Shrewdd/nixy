# Single source of truth for all available themes
{pkgs}: let
  rosepine = import ./wallpapers/rosepine.nix {inherit pkgs;};
in {
  rose-pine = {
    wallpaper = rosepine.miami;
    wallpaperDir = rosepine.directory;
    base16Scheme = import ./theme/rose-pine-dawn-base16.nix;
    polarity = "light";
  };
}
