{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "aurora";
  system.stateVersion = "25.11";

  # ── Boot ───────────────────────────────────────────────────────────
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # ── Nix ────────────────────────────────────────────────────────────
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
  };
  nix.gc.options = "--delete-older-than 30d";

  # ── Locale ─────────────────────────────────────────────────────────
  time.timeZone = "Europe/Warsaw";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  console.keyMap = "us";

  # ── Networking ─────────────────────────────────────────────────────
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = lib.mkForce false;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 3732];
  };

  # ── SSH & access ───────────────────────────────────────────────────
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgMUi7ElERM2QYAh4YsXDT1Ak9QtiWk0rCV6Cbab3ur aurora"
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # ── Packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    nixd
    btop
    git
    speedtest-cli
    tree
    nodejs_24
    pnpm
    openssl
    prisma-engines
  ];

  programs.nh = {
    enable = true;
    flake = "/home/km/nixy";
  };
  programs.nix-ld.enable = true;

  # ── PostgreSQL ─────────────────────────────────────────────────────
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
    ensureDatabases = ["tyraax" "clerk"];
    ensureUsers = [
      {
        name = "tyraax";
        ensureDBOwnership = true;
        ensureClauses = {
          createdb = true;
          login = true;
        };
      }
      {
        name = "clerk";
        ensureDBOwnership = true;
        ensureClauses = {
          createdb = true;
          login = true;
        };
      }
    ];
  };

  services.postgresqlBackup = {
    enable = true;
    startAt = "02:00:00";
    compression = "zstd";
    compressionLevel = 9;
    location = "/var/backup/postgresql";
  };

  # ── Environment ────────────────────────────────────────────────────
  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
    PNPM_HOME = "/home/km/.local/share/pnpm";
  };

  environment.profileRelativeSessionVariables = {
    PATH = [".local/share/pnpm"];
  };
}
