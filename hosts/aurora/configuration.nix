{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "aurora";
  system.stateVersion = "25.11";

  # ===================================
  # Boot Configuration
  # ===================================
  # GRUB on /dev/sda
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # ===================================
  # Nix Configuration
  # ===================================
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;  # Deduplicate store files automatically
  };

  # Auto-cleanup old generations weekly (keep 30 days)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ===================================
  # Networking & Firewall
  # ===================================
  networking.useDHCP = lib.mkDefault true;
  
  # Only SSH allowed by default
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    # allowedUDPPorts = [ ];
  };

  # ===================================
  # Localization
  # ===================================
  time.timeZone = "Europe/Warsaw";  # Server in Poland
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # ===================================
  # User Configuration
  # ===================================
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObivn9a8x+FkEdQEYe7BvkRf7bOxWQgHRKhUXUic8uU tyraaxvps"
    ];
  };

  # Allow sudo without password for wheel group (convenient for automation)
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # ===================================
  # SSH Configuration
  # ===================================
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;  # SSH keys only
    };
  };

  # No root SSH - use km + sudo instead

  # ===================================
  # System Packages
  # ===================================
  environment.systemPackages = with pkgs; [
    nixfmt
    speedtest-cli
    tree
    
    # Discord bot stuff
    nodejs_24
    pnpm
  ];

  # ===================================
  # Programs & Services
  # ===================================
  programs.nh = {
    enable = true;
    flake = "/home/km/nixy";
  };

  programs.nix-ld.enable = true;  # For VS Code Remote SSH

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    imports = [
      ../../modules/home-manager/features/shell/zsh.nix
      ../../modules/home-manager/features/shell/starship.nix
      ../../modules/home-manager/features/shell/btop.nix
      ../../modules/home-manager/features/shell/fastfetch.nix
      ../../modules/home-manager/features/dev/git.nix
    ];

    hm = {
      shell = {
        zsh.enable = true;
        starship.enable = true;
        btop.enable = true;
        fastfetch.enable = true;
      };
      dev.git.enable = true;
    };

    programs.home-manager.enable = true;
    
    home = {
      username = "km";
      homeDirectory = "/home/km";
      stateVersion = "24.05";
      packages = [ ];
    };
  };
}
