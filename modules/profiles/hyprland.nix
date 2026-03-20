# ── Hyprland – complete desktop profile ─────────────────────────────────
#
# Everything a Hyprland workstation needs in one file: shared system
# plumbing, the compositor itself, and Home Manager user config.
# Import this from a host — it takes care of both halves.
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

  # ── System packages ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    playerctl
    libsecret
    seahorse
    hyprpolkitagent
    (pkgs.sddm-astronaut.override {embeddedTheme = "pixel_sakura";})
    imv # image viewer
    mpv # video player
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
      ../home/nixvim.nix
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

        utilities.toasts.capsLockChanged = false;

        bar = {
          # Hide the bar on the secondary display; include both common
          # names so hotplug renames don't re-enable it.
          excludedScreens = ["HDMI-A-2" "HDMI-A-5"];
          workspaces.perMonitorWorkspaces = false;
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

        # ── Autostart ─────────────────────────────────────────────────
        exec-once = [
          "hyprpolkitagent"
        ];

        # ── Monitors ─────────────────────────────────────────────────
        monitor = [
          "desc:Samsung Electric Company LS24C33xG H9TX501846, 1920x1080@100, 0x0, 1"
          "desc:Samsung Electric Company LS24C33xG H9TX501795, 1920x1080@100, 1920x0, 1"
        ];

        # ── Layout & gaps ────────────────────────────────────────────
        general = {
          layout = "dwindle";
          border_size = 3;
          gaps_in = 2;
          gaps_out = 8;
        };

        dwindle.preserve_split = true;

        group.groupbar = {
          font_size = 11;
          gradients = false;
        };

        # ── Eye-candy ────────────────────────────────────────────────
        decoration = {
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

        animations = {
          enabled = true;
          bezier = [
            "wind,   0.05, 0.9,  0.1, 1.05"
            "winIn,  0.1,  1.1,  0.1, 1.1"
            "winOut, 0.3, -0.3,  0,   1"
            "liner,  1,    1,    1,   1"
          ];
          animation = [
            "windows,     1, 6,  wind,    slide"
            "windowsIn,   1, 6,  winIn,   slide"
            "windowsOut,  1, 5,  winOut,  slide"
            "windowsMove, 1, 5,  wind,    slide"
            "border,      1, 1,  liner"
            "borderangle, 1, 30, liner,   loop"
            "fade,        1, 10, default"
            "workspaces,  1, 5,  wind"
          ];
        };

        # ── Keybinds ─────────────────────────────────────────────────
        bind = [
          # Launchers
          "$mainMod,       RETURN, exec,            $terminal"
          "$mainMod,       E,      exec,            $fileManager"

          # Window management
          "$mainMod,       Q,      killactive,"
          "$mainMod,       M,      exit,"
          "$mainMod,       V,      togglefloating,"
          "$mainMod,       P,      pseudo"
          "$mainMod,       J,      togglesplit"

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

          # Caelestia
          "$mainMod,       A,      global,          caelestia:launcher"
          "$mainMod,       Escape, global,          caelestia:session"
          "$mainMod,       L,      global,          caelestia:lock"

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
          ",XF86AudioRaiseVolume, exec, bash -c 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol -a \"Volume\" \"Volume: $vol%\"'"
          ",XF86AudioLowerVolume, exec, bash -c 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol -a \"Volume\" \"Volume: $vol%\"'"
          ",XF86AudioMute, exec, bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@) && if echo \"$vol_info\" | grep -q MUTED; then notify-send -r 9991 -h int:value:0 -a \"Volume\" \"Volume: Muted\"; else vol_num=$(echo \"$vol_info\" | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol_num -a \"Volume\" \"Volume: $vol_num%\"; fi'"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];

        bindl = [
          ", XF86AudioNext,  exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay,  exec, playerctl play-pause"
          ", XF86AudioPrev,  exec, playerctl previous"
        ];

        # ── Window rules ─────────────────────────────────────────────
        windowrule = [
          "suppress_event maximize, match:class .*"
          "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
        ];

        # ── Input ────────────────────────────────────────────────────
        input.kb_layout = "pl";

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
