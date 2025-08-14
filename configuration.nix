{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  #######################
  # Boot & System
  #######################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #######################
  # Home Manager
  #######################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.km = {
    # Modular package configuration
    imports = [
      ./home-manager/home.nix
      ./home-manager/spotify/default.nix
      ./home-manager/hyprland/default.nix
      ./home-manager/waybar/default.nix
    ];
    home.stateVersion = "25.05";
  };

  #######################
  # Hostname & Networking
  #######################
  networking.hostName = "nixy";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  #######################
  # Localization
  #######################
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  #######################
  # Keyboard
  #######################
  services.xserver.xkb.layout = "pl";
  services.xserver.xkb.variant = "";
  console.keyMap = "pl2";

  #######################
  # Users
  #######################
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  #######################
  # Hardware
  #######################
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  #######################
  # Desktop Environment / WM
  #######################

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --time --remember --remember-session --asterisks";
        user = "greeter";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  #######################
  # Software Packages
  #######################
  nixpkgs.config.allowUnfree = true;

  # System-wide core apps
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    kitty
    nautilus
    pavucontrol
    rofi
    jq
    curl
    lm_sensors
    brightnessctl
    git
  ];

  # Install Nerd Font system-wide (new nerd-fonts namespace)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  #######################
  # Services & Programs
  #######################
  services.flatpak.enable = true;

  # GNOME Keyring (password/key storage)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;  # unlock via greetd login

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.steam.enable = true;
}
