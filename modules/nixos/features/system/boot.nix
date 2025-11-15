{ config, lib, pkgs, ... }:

{
  options.features.system.boot = {
    enable = lib.mkEnableOption "systemd-boot bootloader";
    
    latestKernel = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use latest kernel packages";
    };
  };

  config = lib.mkIf config.features.system.boot.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    boot.kernelPackages = lib.mkIf config.features.system.boot.latestKernel 
      pkgs.linuxPackages_latest;
  };
}
