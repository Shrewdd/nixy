{ config, lib, pkgs, ... }:

# Minimal aurora configuration (safe for remote VPS)
{
  imports = [ ./hardware-configuration.nix ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;

  # Set hostname
  networking.hostName = "aurora";

  system.stateVersion = "25.11"; # keep the original stateVersion

  # Keep SSH enabled. Permit root login by public key only (temporary).
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # Keep your km user's public key so you won't be locked out.
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObivn9a8x+FkEdQEYe7BvkRf7bOxWQgHRKhUXUic8uU tyraaxvps"
    ];
  };

  # Root authorized keys placeholder. To enable key-based root login, add the
  # public key you generate locally (see instructions). Example:
  # users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA... aurora" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgMUi7ElERM2QYAh4YsXDT1Ak9QtiWk0rCV6Cbab3ur aurora"
  ];

  # Enable firewall but allow SSH so remote access remains available.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages: keep speedtest-cli available
  environment.systemPackages = with pkgs; [
    speedtest-cli
    ];

  # Allow sudo for users in wheel group without password
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    imports = [ ../../modules/home-manager/profiles/base.nix ];

    # Host-specific packages
    home.packages = with pkgs; [ tree ];
  };
}
