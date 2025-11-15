{ config, lib, pkgs, ... }:

{
  options.features.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support";
    
    enableBlueman = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Blueman GUI (disable if using GNOME's built-in bluetooth)";
    };
  };

  config = lib.mkIf config.features.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = lib.mkDefault true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    # Enable blueman for GUI management (optional)
    services.blueman.enable = config.features.hardware.bluetooth.enableBlueman;
  };
}
