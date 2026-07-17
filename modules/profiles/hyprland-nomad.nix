# ── Hyprland laptop profile (NOMAD) ─────────────────────────────────────────────
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # ════════════════════════════════════════════════════════════════════════
  # ── NixOS ──────────────────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

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
  services.displayManager.gdm.enable = lib.mkForce false;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      qt6Packages.qtmultimedia
      qt6Packages.qtsvg
      qt6Packages.qtvirtualkeyboard
    ];
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
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  # ── Secrets & auth ─────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;

  services.thermald.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  # ── System Packages ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    playerctl
    libsecret
    seahorse
    hyprpolkitagent
    brightnessctl
    imv
    mpv
    (pkgs.sddm-astronaut.override {embeddedTheme = "hyprland_kath";})
  ];

  # ── Session Environment ────────────────────────────────────────────
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

        bar = {
          persistent = false;
          showOnHover = true;
          workspaces.perMonitorWorkspaces = false;
        };

        utilities = {
          toasts = {
            capsLockChanged = false; # disable caps-lock toast
          };
        };
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

      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "ghostty";
        "$fileManager" = "nautilus";
        "$browser" = "zen-twilight";
        "$wallpaperDir" = "${osConfig.nixy.stylix.wallpaperDir}";

        # ── Autostart ─────────────────────────────────────────────────
        exec-once = [
          "hyprpolkitagent"
        ];

        # ── Laptop Screen Configuration ───────────────────────────────
        monitor = [
          "eDP-1, preferred, auto, 1"
        ];

        # ── Layout & Minimalist Gaps ──────────────────────────────────
        general = {
          layout = "scrolling";
          border_size = 2;
          gaps_in = 2;
          gaps_out = 4;
        };

        scrolling = {
          column_width = 0.5;
          follow_focus = true;
          fullscreen_on_one_column = true;
          wrap_focus = true;
          wrap_swapcol = true;
          direction = "right";
        };

        # ── Trackpad Gestures ───────────────────────────────────────
        gesture = "3, horizontal, workspace";

        group.groupbar = {
          font_size = 11;
          gradients = false;
        };

        # ── Visual Effects (Aggressive iGPU / Battery Optimization) ──
        decoration = {
          rounding = 8;
          blur = {
            enabled = false;
          };
          shadow = {
            enabled = false;
          };
        };

        # ── Instantaneous Animations (60Hz Tweak) ─────────────────────
        animations = {
          enabled = true;
          bezier = [
            "snappy, 0.1, 1.0, 0.1, 1.0"
          ];
          animation = [
            "windows,     1, 2, snappy, slide"
            "windowsIn,   1, 2, snappy, slide"
            "windowsOut,  1, 2, snappy, slide"
            "windowsMove, 1, 2, snappy, slide"
            "border,      1, 1, snappy"
            "fade,        1, 4, default"
            "workspaces,  1, 3, snappy, slide"
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
          "$mainMod,       J,      layoutmsg,       swapcol l"
          "$mainMod,       K,      layoutmsg,       move +col"

          # Focus
          "$mainMod,       left,   movefocus,       l"
          "$mainMod,       right,  movefocus,       r"
          "$mainMod,       up,     movefocus,       u"
          "$mainMod,       down,   movefocus,       d"

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

          # Caelestia Ecosystem Actions
          "$mainMod,       A,      global,          caelestia:launcher"
          "$mainMod,       Escape, global,          caelestia:session"
          "$mainMod,       G,      exec,            caelestia shell gameMode toggle"
          "$mainMod,       L,      global,          caelestia:lock"
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
        bindel = [
          ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];

        bindl = [
          ", XF86AudioNext,  exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay,  exec, playerctl play-pause"
          ", XF86AudioPrev,  exec, playerctl previous"
        ];

        windowrule = [
          "match:class .*, suppress_event maximize"
          "match:class ^$ match:title ^$ match:xwayland 1 match:float 1 match:fullscreen 0 match:pin 0, no_focus on"
        ];

        # ── Input ────────────────────────────────────────────────────
        input.kb_layout = "pl";
        input.touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
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
      };
    };
  };
}
