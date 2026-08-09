# Available Stylix theme profiles
#
{pkgs}: {
  rose-pine-dawn = {
    wallpaper = ./wallpapers/leafy-dawn.jpg;
    wallpaperDir = pkgs.linkFarm "rose-pine-dawn-wallpapers" [
      {
        name = "leafy-dawn.jpg";
        path = ./wallpapers/leafy-dawn.jpg;
      }
      {
        name = "mountains-dawn.jpg";
        path = ./wallpapers/mountains-dawn.jpg;
      }
    ];
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
    polarity = "light";
  };

  rose-pine-moon = {
    wallpaper = ./wallpapers/leafy-moon.jpg;
    wallpaperDir = pkgs.linkFarm "rose-pine-moon-wallpapers" [
      {
        name = "leafy-moon.jpg";
        path = ./wallpapers/leafy-moon.jpg;
      }
      {
        name = "mountains-moon.jpg";
        path = ./wallpapers/mountains-moon.jpg;
      }
    ];
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    polarity = "dark";
  };
}
