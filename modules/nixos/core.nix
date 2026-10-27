{
  lib,
  pkgs,
  inputs,
  ...
}: {
  # ── Defaults policy ───────────────────────────────────────────────
  # Shared defaults use mkDefault so hosts can override per machine.

  # ── Shell ──────────────────────────────────────────────────────────
  programs.fish.enable = true;

  # ── Users ──────────────────────────────────────────────────────────
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
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
  boot.loader.timeout = 3;

  # ── Plymouth ───────────────────────────────────────────────────────
  boot.plymouth = {
    enable = true;
    theme = lib.mkForce "gifmouth";
    themePackages = with pkgs; [
      (callPackage (inputs.plymouth-gifmouth-theme + /package.nix) {
        gifSource = "https://media1.tenor.com/m/iNppQklYYnYAAAAd/furry-boykisser-dance-furry.gif";
        gifHash = "sha256:1chhj4lylggpykcrpr4f6ri2kqkmayasqix35sg589xlnc2ajgmh";
      })
    ];
  };

  # Silent boot
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "rd.systemd.show_status=auto"
  ];

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
