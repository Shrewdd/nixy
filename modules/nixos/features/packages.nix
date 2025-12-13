{ config, lib, pkgs, ... }:

{
  options.packages = {
    # Shared packages enabled by default on all hosts
    shared = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable shared packages across all hosts";
      };
    };

    # Host-specific package sets
    monsoon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Monsoon-specific packages (gaming, development, Discord)";
      };
    };

    nomad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Nomad-specific packages (lightweight apps)";
      };
    };
  };

  config = lib.mkMerge [
    # ===================================
    # SHARED PACKAGES (All Hosts)
    # ===================================
    (lib.mkIf config.packages.shared.enable {
      # Shared fonts
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
      ];

      # Common applications
      environment.systemPackages = with pkgs; [
        nixfmt
        vscode
        veracrypt                  # Disk encryption
        kdePackages.gwenview       # Image viewer
      ];

      # Common programs
      programs.localsend = {
        enable = true;
        openFirewall = true;
      };

      programs.nh = {
        enable = true;
        flake = "/home/km/nixy";
      };

      programs.zoom-us.enable = true;
      programs.dconf.enable = true;
    })

    # ===================================
    # MONSOON PACKAGES
    # ===================================
    (lib.mkIf config.packages.monsoon.enable {
      environment.systemPackages = with pkgs; [
        # Communication
        vesktop                    # Discord client
        
        # Gaming
        lutris                     # Game installer/runner
        sixpair                    # PS3 controller pairing
        
        # Utilities
        appimage-run               # AppImage support
        lshw                       # PCIe Hardware info
        speedtest-cli              # Internet speed test
        
        # Roblox Development
        rojo                       # Roblox Development Tool
        wally                      # Roblox Package Manager
        selene                     # Lua Linter
        luau-lsp                   # Luau Language Server
        stylua                     # Lua Formatter
      ];

      # Gaming programs
      programs.gamemode.enable = true;
      programs.steam.enable = true;
    })

    # ===================================
    # NOMAD PACKAGES
    # ===================================
    (lib.mkIf config.packages.nomad.enable {
      environment.systemPackages = with pkgs; [
        # Add nomad-specific packages here
      ];
    })
  ];
}
