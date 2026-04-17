{lib, ...}: {
  # ── Defaults policy ───────────────────────────────────────────────
  # Shared defaults use mkDefault so hosts can override per machine.

  # ── Users ──────────────────────────────────────────────────────────
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = ["networkmanager" "wheel"];
  };

  # ── Nix ────────────────────────────────────────────────────────────
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = lib.mkDefault true;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # ── Networking ─────────────────────────────────────────────────────
  networking.networkmanager.enable = true;
  networking.firewall.enable = lib.mkDefault true;

  # ── Boot ───────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Locale ─────────────────────────────────────────────────────────
  time.timeZone = lib.mkDefault "Europe/Warsaw";

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = lib.mkDefault {
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

  console.keyMap = lib.mkDefault "us";
}
