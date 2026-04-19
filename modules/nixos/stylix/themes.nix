# Available Stylix theme profiles
{pkgs}: let
  rose-pine-dawn = import ./wallpapers/rose-pine-dawn.nix {inherit pkgs;};
in {
  rose-pine-dawn = {
    wallpaper = rose-pine-dawn.pnkMd;
    wallpaperDir = rose-pine-dawn.directory;
    base16Scheme = import ./theme/rose-pine-dawn-base16.nix;
    polarity = "light";
  };

  rose-pine-moon = {
    wallpaper = rose-pine-dawn.pnkMd;
    wallpaperDir = rose-pine-dawn.directory;
    base16Scheme = import ./theme/rose-pine-moon-base16.nix;
    polarity = "dark";
  };
}
