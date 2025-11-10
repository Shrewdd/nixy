{ config, pkgs, ... }:

{
  # Enable flatpak support
  services.flatpak = {
    enable = true;
  };
}
