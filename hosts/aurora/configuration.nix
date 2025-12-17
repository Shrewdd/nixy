{ lib, pkgs, ... }:

let
  prismaEnginesOverlay = final: prev: {
    prisma-engines = prev.prisma-engines.overrideAttrs (_: rec {
      version = "7.1.0";
      src = final.fetchFromGitHub {
        owner = "prisma";
        repo = "prisma-engines";
        rev = "7.1.0";
        hash = "sha256-RBHUJI6QG37cMVGciQAWrmMnEhgRW/B8/BxpLhK09OQ=";
      };
      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-n83hJfSlvuaoBb3w9Rk8+q2emjGCoPDHhFdoVzhf4sM=";
      };
      cargoBuildFlags = [
        "--package" "query-compiler"
        "--package" "schema-engine-cli"
        "--package" "prisma-fmt"
      ];
      postInstall = ''
        mv $out/bin/query-engine-node-api $out/bin/query-engine || true
        mv $out/lib/libquery_engine*.so $out/lib/libquery_engine.node || true
      '';
    });
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/profiles/server.nix
  ];

  networking.hostName = "aurora";
  system.stateVersion = "25.11";

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  nix.settings.auto-optimise-store = true;
  nix.gc.options = "--delete-older-than 30d";
  nixpkgs.overlays = [ prismaEnginesOverlay ];

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = lib.mkForce false;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  users.users.km = {
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

  environment.systemPackages = with pkgs; [
    nixfmt
    speedtest-cli
    tree
    nodejs_24
    pnpm
    openssl
  ];

  programs.nh = {
    enable = true;
    flake = "/home/km/nixy";
  };
  programs.nix-ld.enable = true;

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

  services.postgresqlBackup = {
    enable = true;
    startAt = "02:00:00";
    compression = "zstd";
    compressionLevel = 9;
    location = "/var/backup/postgresql";
  };

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
  };

  home-manager.users.km = {
    imports = [ ../../modules/user/profiles/server.nix ];
    home = {
      packages = [ ];
      sessionVariables.PNPM_HOME = "/home/km/.local/share/pnpm";
      sessionPath = [ "$PNPM_HOME" ];
    };
  };
}
