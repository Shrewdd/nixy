{ config, lib, pkgs, ... }:

{
  options.features.system.nix = {
    enable = lib.mkEnableOption "Nix flakes and modern features";
    
    autoOptimise = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically optimize nix store";
    };

    gc = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable automatic garbage collection";
      };

      dates = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = "When to run garbage collection";
      };

      options = lib.mkOption {
        type = lib.types.str;
        default = "--delete-older-than 7d";
        description = "Options for garbage collection";
      };
    };
  };

  config = lib.mkIf config.features.system.nix.enable {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = config.features.system.nix.autoOptimise;
      };

      gc = lib.mkIf config.features.system.nix.gc.enable {
        automatic = true;
        dates = config.features.system.nix.gc.dates;
        options = config.features.system.nix.gc.options;
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
}
