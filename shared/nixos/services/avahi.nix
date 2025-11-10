{ config, pkgs, ... }:

{
  # Enable Avahi for mDNS resolution (.local names)
  services.avahi = {
    enable = true;
    openFirewall = true;
  };
}
