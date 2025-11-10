{ config, pkgs, ... }:

{
  # Shared display basics: enable basic display support and keyboard layout
  services.xserver.enable = true;

  # Keyboard layout settings for X11 and console (most hosts use Polish layout)
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  console.keyMap = "pl2";

  # Keep this file focused: per-host or per-WM specifics belong to their modules.
}
