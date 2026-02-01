{
  lib,
  pkgs,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint hplip];
  };

  # Need to figure out why avahi fails to start mDNS/DNS-SD Stack
  services.avahi = {
    enable = lib.mkDefault false;
    nssmdns4 = true;
    openFirewall = true;
  };
}
