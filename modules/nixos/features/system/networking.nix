{ config, lib, pkgs, ... }:

{
  options.features.system.networking = {
    enable = lib.mkEnableOption "NetworkManager networking";
    
    firewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable firewall";
    };
  };

  config = lib.mkIf config.features.system.networking.enable {
    networking.networkmanager.enable = true;
    networking.firewall.enable = config.features.system.networking.firewall;
  };
}
