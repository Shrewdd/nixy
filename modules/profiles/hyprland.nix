# ── Hyprland desktop profile ─────────────────────────────────────────────
#
# Host-level profile for Hyprland machines (desktop + laptop).
# Combines shared NixOS modules with Home Manager user modules.
#
{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  isNomad = config.networking.hostName == "nomad";
in {
  # ════════════════════════════════════════════════════════════════════════
  # ── NixOS ──────────────────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  # ── Common desktop plumbing ──────────────────────────────────────────
  imports = [
    ../nixos/stylix/theme-profiles.nix
    ../nixos/core.nix
    ../nixos/nautilus.nix
    ../nixos/audio.nix
    ../nixos/bluetooth.nix
    ../nixos/flatpak.nix
    ../nixos/printing.nix
    ../nixos/packages.nix
  ];

  # ── Display Manager ──────────────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd 'uwsm start hyprland-uwsm.desktop'";
      user = "greeter";
    };
  };

  # ── Hyprland & portals ──────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.gpu-screen-recorder.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];

    # Ensure screencast/screenshot requests are handled by the Hyprland portal.
    # Without this, the session may pick the GTK portal first, which doesn't
    # provide the screen-share picker under Hyprland.
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  # ── Secrets & auth ─────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # ── Power & thermal ────────────────────────────────────────────────
  services.upower.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login.HandleLidSwitch = lib.mkIf isNomad "suspend";

  # ── System packages ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    libsecret
    seahorse
    imv
    mpv
  ];

  # ── Session environment ────────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
    XDG_SESSION_TYPE = lib.mkDefault "wayland";
    XDG_SESSION_DESKTOP = lib.mkDefault "Hyprland";
    XDG_CURRENT_DESKTOP = lib.mkDefault "Hyprland";
  };

  # ════════════════════════════════════════════════════════════════════════
  # ── Home Manager (km) ──────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  home-manager.users.km = {osConfig, ...}: {
    imports = [
      inputs.caelestia-shell.homeManagerModules.default
      ../home/core.nix
      ../home/ghostty.nix
      ../home/zen.nix
      ../home/spotify.nix
    ];

    # ── Stylix ────────────────────────────────────────────────────────
    stylix.targets.hyprland.enable = false;

    # ── Caelestia shell ────────────────────────────────────────────────
    programs.caelestia = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };

      settings = {
        general.apps = {
          terminal = ["ghostty"];
          explorer = ["nautilus"];
        };

        paths.wallpaperDir = "${osConfig.nixy.stylix.wallpaperDir}";

        services.weatherLocation = "";

        background.desktopClock.enabled = true;

        utilities.toasts.capsLockChanged = false;

        bar =
          {workspaces.perMonitorWorkspaces = false;}
          // (
            if isNomad
            then {
              persistent = false;
              showOnHover = true;
            }
            else {
              # Hide the bar on the secondary display; include both common
              # names so hotplug renames don't re-enable it.
              excludedScreens = ["HDMI-A-2" "HDMI-A-5"];
            }
          );
      };

      cli = {
        enable = true;
        settings.theme.enableGtk = false;
      };
    };

    # ── Hyprland window manager ──────────────────────────────────────
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;

      settings =
        {
          "$mainMod" = "SUPER";
          "$terminal" = "ghostty";
          "$fileManager" = "nautilus";
          "$browser" = "zen-twilight";
          "$wallpaperDir" = "${osConfig.nixy.stylix.wallpaperDir}";

          # ── Autostart ─────────────────────────────────────────────────
          exec-once = [
            "${lib.getExe pkgs.hyprpolkitagent}"
          ];

          # ── Monitors ─────────────────────────────────────────────────
          monitor =
            if isNomad
            then ["eDP-1, preferred, auto, 1"]
            else [
              "desc:Samsung Electric Company LS24C33xG H9TX501846, 1920x1080@100, 0x0, 1"
              "desc:Samsung Electric Company LS24C33xG H9TX501795, 1920x1080@100, 1920x0, 1"
            ];

          # ── Layout & gaps ────────────────────────────────────────────
          general = {
            layout = "dwindle";
            border_size =
              if isNomad
              then 2
              else 3;

            gaps_in = 2;
            gaps_out =
              if isNomad
              then 4
              else 8;
          };

          dwindle = {
            preserve_split = true;
          };

          group.groupbar = {
            font_size = 11;
            gradients = false;
          };

          # ── Visual effects ───────────────────────────────────────────
          decoration =
            if isNomad
            then {
              rounding = 8;
              blur.enabled = false;
              shadow.enabled = false;
            }
            else {
              rounding = 10;
              blur = {
                enabled = true;
                size = 3;
                passes = 1;
                new_optimizations = true;
              };
              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
              };
            };

          # ── Animations ───────────────────────────────────────────────
          animations = {
            enabled = true;

            bezier = [
              "easeOutExpo, 0.16, 1, 0.3, 1"
              "easeOutCubic, 0.33, 1, 0.68, 1"
            ];

            animation = [
              "windows,     1, 2.5, easeOutExpo, popin 80%"
              "windowsIn,   1, 2.5, easeOutExpo, popin 80%"
              "windowsOut,  1, 2,   easeOutCubic, popin 80%"
              "windowsMove, 1, 2.5, easeOutExpo"
              "border,      1, 2,   default"
              "fade,        1, 2,   default"
              "workspaces,  1, 2.5, easeOutExpo, slide"
            ];
          };

          # ── Keybinds ─────────────────────────────────────────────────
          bind = [
            # Launchers
            "$mainMod,       RETURN, exec,            $terminal"
            "$mainMod,       E,      exec,            $fileManager"
            "$mainMod,       B,      exec,            $browser"

            # Window management
            "$mainMod,       Q,      killactive,"
            "$mainMod,       M,      exec,            uwsm stop"
            "$mainMod,       V,      togglefloating,"
            "$mainMod ALT,   J,      layoutmsg, togglesplit"

            # Focus (vim home-row, arrows kept as an alternate)
            "$mainMod,       H,      movefocus,       l"
            "$mainMod,       J,      movefocus,       d"
            "$mainMod,       K,      movefocus,       u"
            "$mainMod,       L,      movefocus,       r"
            "$mainMod,       left,   movefocus,       l"
            "$mainMod,       right,  movefocus,       r"
            "$mainMod,       up,     movefocus,       u"
            "$mainMod,       down,   movefocus,       d"

            # Move window (vim home-row)
            "$mainMod SHIFT, H,      movewindow,      l"
            "$mainMod SHIFT, J,      movewindow,      d"
            "$mainMod SHIFT, K,      movewindow,      u"
            "$mainMod SHIFT, L,      movewindow,      r"

            # Workspace cycling
            "$mainMod,       Tab,    workspace,       e+1"
            "$mainMod SHIFT, Tab,    workspace,       e-1"

            # Switch workspace
            "$mainMod,       1,      workspace,       1"
            "$mainMod,       2,      workspace,       2"
            "$mainMod,       3,      workspace,       3"
            "$mainMod,       4,      workspace,       4"
            "$mainMod,       5,      workspace,       5"
            "$mainMod,       6,      workspace,       6"
            "$mainMod,       7,      workspace,       7"
            "$mainMod,       8,      workspace,       8"
            "$mainMod,       9,      workspace,       9"
            "$mainMod,       0,      workspace,       10"

            # Move window to workspace
            "$mainMod SHIFT, 1,      movetoworkspace, 1"
            "$mainMod SHIFT, 2,      movetoworkspace, 2"
            "$mainMod SHIFT, 3,      movetoworkspace, 3"
            "$mainMod SHIFT, 4,      movetoworkspace, 4"
            "$mainMod SHIFT, 5,      movetoworkspace, 5"
            "$mainMod SHIFT, 6,      movetoworkspace, 6"
            "$mainMod SHIFT, 7,      movetoworkspace, 7"
            "$mainMod SHIFT, 8,      movetoworkspace, 8"
            "$mainMod SHIFT, 9,      movetoworkspace, 9"
            "$mainMod SHIFT, 0,      movetoworkspace, 10"

            # Special workspace
            "$mainMod,       S,      togglespecialworkspace, magic"
            "$mainMod SHIFT, S,      movetoworkspace,        special:magic"

            # Scroll through workspaces
            "$mainMod,       mouse_down, workspace,   e+1"
            "$mainMod,       mouse_up,   workspace,   e-1"

            # Caelestia ecosystem actions
            "$mainMod,       A,      global,          caelestia:launcher"
            "$mainMod,       Escape, global,          caelestia:session"
            "$mainMod,       G,      exec,            caelestia shell gameMode toggle"
            "$mainMod CTRL,  L,      global,          caelestia:lock"
            "$mainMod,       W,      exec,            caelestia wallpaper -r $wallpaperDir && caelestia scheme set -m ${osConfig.nixy.stylix.polarity}"

            # Screenshots
            "$mainMod,       Print,  exec,            caelestia screenshot --freeze"
            ",               Print,  exec,            caelestia screenshot --region --freeze"
            "$mainMod ALT,   Print,  exec,            caelestia screenshot --all --freeze"
          ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          # ── Media / hardware keys ────────────────────────────────────
          bindel =
            [
              ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
              ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ]
            ++ lib.optionals isNomad [
              ",XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} set 5%+"
              ",XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} set 5%-"
            ];

          bindl = [
            ", XF86AudioNext,  exec, ${lib.getExe pkgs.playerctl} next"
            ", XF86AudioPause, exec, ${lib.getExe pkgs.playerctl} play-pause"
            ", XF86AudioPlay,  exec, ${lib.getExe pkgs.playerctl} play-pause"
            ", XF86AudioPrev,  exec, ${lib.getExe pkgs.playerctl} previous"
          ];

          # ── Window rules ─────────────────────────────────────────────
          windowrule = [
            "suppress_event maximize, match:class .*"
            "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
          ];

          # ── Input ────────────────────────────────────────────────────
          input =
            {kb_layout = "pl";}
            // lib.optionalAttrs isNomad {
              touchpad = {
                natural_scroll = true;
                disable_while_typing = true;
              };
            };

          # ── Cursor ───────────────────────────────────────────────────
          env = [
            "XCURSOR_THEME,Bibata-Modern-Ice"
            "XCURSOR_SIZE,24"
          ];

          # ── Misc ─────────────────────────────────────────────────────
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };
        }
        // lib.optionalAttrs isNomad {
          # ── Trackpad gestures ───────────────────────────────────────
          gesture = "3, horizontal, workspace";
        };
    };
  };
}
