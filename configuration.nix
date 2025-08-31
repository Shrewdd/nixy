{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware/graphics.nix
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

  #######################
  # Nix-Helper
  #######################
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/km/nixy";
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

  #######################
  # Desktop Environment / WM
  #######################
  security.pam.services.greetd.enableGnomeKeyring = true;
  # security.pam.services.login.enableGnomeKeyring = true;

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
    tuigreet
    ghostty
    pavucontrol
    playerctl
    jq
    curl
    brightnessctl
    libsecret
    seahorse
    xarchiver
    appimage-run
    sixpair
    # Notification utils
    libnotify
    # Screenshot utils
    grimblast
    wl-clipboard
  ];

  # Install Nerd Font system-wide (new nerd-fonts namespace)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  #######################
  # Services & Programs
  #######################
  services.flatpak.enable = true;

  security.rtkit.enable = true; # realtime scheduling for low-latency audio
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;          # master switch for PipeWire
    audio.enable = true;    # ensure audio (can be implicit, made explicit here)
    alsa.enable = true;     # ALSA clients
    alsa.support32Bit = true; # 32‑bit (Steam / older games)
    pulse.enable = true;    # PulseAudio compatibility layer (keep for desktop apps)
    jack.enable = false;    # Disable JACK (can re-enable if doing pro audio)
    wireplumber = {
      enable = true; # session manager
      extraConfig."10-bluetooth" = {
        "monitor.bluez.properties" = {
          # bt audio: sbc + sbc_xq = stable + low-ish delay for my oppo buds; aac = fallback
          # removed ldac (felt slower). allow default roles again (fix "no audio endpoints" issue)
          # need mic? msbc true later. crackles loud? drop sbc_xq or raise quantum
          "bluez5.codecs" = [ "sbc" "sbc_xq" "aac" ];
          "bluez5.enable-msbc" = false;
          "bluez5.enable-hw-volume" = true;
          "bluez5.enable-sbc-xq" = true;
        };
      };
    };
    # Extra tuning: correct option paths per `services.pipewire.extraConfig.*` / `services.pipewire.wireplumber.extraConfig`.
    extraConfig.pipewire."10-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 48000 44100 ];
        "default.clock.quantum" = 128;      # was 64
        "default.clock.min-quantum" = 64;   # was 32
        "default.clock.max-quantum" = 256;  # was 128
        "resample.quality" = 4; # 0..10 (higher = better qual, more latency)
      };
    };
  };

  # GNOME Keyring (password/key storage)
  services.gnome.gnome-keyring.enable = true;

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.steam.enable = true;
  # Thunar utils
  programs.thunar.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-filters ];
  };
}
