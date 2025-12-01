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
  time.timeZone = "Europe/Warsaw";
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgMUi7ElERM2QYAh4YsXDT1Ak9QtiWk0rCV6Cbab3ur aurora"
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

  # No root SSH - using km instead

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
    openssl
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
  # PostgreSQL
  # ===================================
  services.postgresql = {
    enable = true;
    settings = {
      listen_addresses = lib.mkForce "127.0.0.1";
      max_connections = 10;
    };
    authentication = ''
      local   all             all                                     peer
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
    '';
    ensureDatabases = [ "tyraax" "clerk" ];
    ensureUsers = [
      { name = "tyraax"; ensureDBOwnership = true; ensureClauses = { createdb = true; login = true; }; }
      { name = "clerk"; ensureDBOwnership = true; ensureClauses = { createdb = true; login = true; }; }
    ];
  };

  # Daily backups at 02:00 with zstd compression
  services.postgresqlBackup = {
    enable = true;
    startAt = "02:00:00";
    compression = "zstd";
    compressionLevel = 9;
    location = "/var/backup/postgresql";
  };

  # ===================================
  # Prisma Engines for NixOS
  # ===================================
  # Prisma on NixOS requires explicit engine paths
  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
  };

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
      # Ensure pnpm global bin works without manual setup
      sessionVariables = {
        PNPM_HOME = "/home/km/.local/share/pnpm";
      };
      # Prepend PNPM_HOME to PATH at login shells
      sessionPath = [ "$PNPM_HOME" ];
    };
  };
}
