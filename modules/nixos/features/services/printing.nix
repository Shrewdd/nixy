{ config, lib, pkgs, ... }:

{
  options.features.services.printing = {
    enable = lib.mkEnableOption "Printing support (CUPS)";
    
    enableAvahi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Avahi for printer discovery (mDNS)";
    };
  };

  config = lib.mkIf config.features.services.printing.enable {
    # Enable CUPS
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        hplip
      ];
    };

    # Enable printer discovery via Avahi (optional)
    services.avahi = lib.mkIf config.features.services.printing.enableAvahi {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
