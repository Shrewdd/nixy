{
  lib,
  pkgs,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint hplip];
  };

  services.avahi = {
    enable = lib.mkDefault true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
