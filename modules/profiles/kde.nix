# ── KDE Plasma desktop profile ────────────────────────────────────────────
#
# Host-level profile for KDE Plasma machines.
# Combines shared NixOS modules with Home Manager user modules.
#
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # ════════════════════════════════════════════════════════════════════════
  # ── NixOS ──────────────────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  # ── Common desktop plumbing ──────────────────────────────────────────
  imports = [
    ../nixos/stylix/theme-profiles.nix
    ../nixos/core.nix
    ../nixos/audio.nix
    ../nixos/bluetooth.nix
    ../nixos/flatpak.nix
    ../nixos/printing.nix
    ../nixos/packages.nix
  ];

  # ── Display Manager + Desktop ───────────────────────────────────────
  services.displayManager.gdm.enable = lib.mkForce false;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = lib.mkForce pkgs.kdePackages.sddm;
  };

  # ── Session environment ────────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
    XDG_SESSION_TYPE = lib.mkDefault "wayland";
    XDG_SESSION_DESKTOP = lib.mkDefault "KDE";
    XDG_CURRENT_DESKTOP = lib.mkDefault "KDE";
  };

  # ════════════════════════════════════════════════════════════════════════
  # ── Home Manager (km) ──────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  home-manager.users.km = { ... }: {
    imports = [
      inputs.plasma-manager.homeModules.plasma-manager
      ../home/core.nix
      ../home/ghostty.nix
      ../home/zen.nix
      ../home/spotify.nix
    ];

    programs.plasma = {
      enable = true;

      input.touchpads = [
        {
          naturalScroll = true;
        }
      ];

      panels = [
        {
          location = "bottom";
          height = 36;
          floating = true;
          lengthMode = "fit";
          widgets = [
            "org.kde.plasma.kickoff"
            {
              name = "org.kde.plasma.icontasks";
              config.General = {
                showOnlyIcons = true;
              };
            }
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
          ];
        }
      ];

      hotkeys.commands = {
        "launch-terminal" = {
          name = "Launch Ghostty";
          key = "Meta+Return";
          command = "ghostty";
        };

        "launch-file-manager" = {
          name = "Launch Dolphin";
          key = "Meta+E";
          command = "dolphin";
        };
      };
    };
  };
}
