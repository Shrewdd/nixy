# ── Hyprland desktop profile ─────────────────────────────────────────────
{
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
    ../nixos/thunar.nix
    ../nixos/audio.nix
    ../nixos/bluetooth.nix
    ../nixos/flatpak.nix
    ../nixos/printing.nix
    ../nixos/packages.nix
  ];

  # ── Display Manager ──────────────────────────────────────────────────
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = ["km"];
    settings.keyboard.layout = "pl";
    extraArgs = ["--" "--session" "hyprland-uwsm"];
  };

  # ── Hyprland & portals ──────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # ── Secrets & auth ─────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # ── Power & thermal ────────────────────────────────────────────────
  services.upower.enable = true;
  services.power-profiles-daemon.enable = lib.mkIf isNomad true;
  services.thermald.enable = lib.mkIf isNomad true;
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
  };

  # ════════════════════════════════════════════════════════════════════════
  # ── Home Manager (km) ──────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  home-manager.users.km = {
    imports = [
      ../home/core.nix
      ../home/kitty.nix
      ../home/zen.nix
      ../home/spotify.nix
      ../home/zed.nix
    ];

    # ── Noctalia shell ─────────────────────────────────────────────────
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        shell.launcher.categories = false;
        shell.launch_apps_as_systemd_services = true;
        shell.polkit_agent = true;
        shell.greeter_sync.auto_sync = true;
        location.auto_locate = true;
        shell.screenshot = {
          show_cursor = true;
          annotate = true;
        };
        shell.screen_corners = {
          enabled = true;
          size = 32;
        };
      };
    };

    # ── Hyprland window manager ──────────────────────────────────────
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      configType = "hyprlang"; # lua support is still broken hence why we are on hyprlang

      settings =
        {
          "$mainMod" = "SUPER";
          "$terminal" = "kitty";
          "$fileManager" = "thunar";
          "$browser" = "zen-twilight";

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
            gaps_in = 3;
            gaps_out = 6;
          };

          # ── Animations ───────────────────────────────────────────────
          animations = {
            bezier = [
              "easeOutExpo, 0.16, 1, 0.3, 1"
              "easeOutCubic, 0.33, 1, 0.68, 1"
            ];

            animation = [
              "windows,     1, 1.6, easeOutExpo, popin 80%"
              "windowsIn,   1, 1.6, easeOutExpo, popin 80%"
              "windowsOut,  1, 1.2, easeOutCubic, popin 80%"
              "windowsMove, 1, 1.6, easeOutExpo"
              "border,      1, 1.6, default"
              "fade,        1, 1.6, default"
              "workspaces,  1, 1.6, easeOutExpo, slide"
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
            "$mainMod,       V,      togglefloating,"

            # Focus
            "$mainMod,       left,   movefocus,       l"
            "$mainMod,       right,  movefocus,       r"
            "$mainMod,       up,     movefocus,       u"
            "$mainMod,       down,   movefocus,       d"

            # Move window
            "$mainMod SHIFT, left,   movewindow,      l"
            "$mainMod SHIFT, right,  movewindow,      r"
            "$mainMod SHIFT, up,     movewindow,      u"
            "$mainMod SHIFT, down,   movewindow,      d"

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

            # Noctalia ecosystem actions
            "$mainMod,       A,      exec,            noctalia msg panel-toggle launcher"
            "$mainMod,       Escape, exec,            noctalia msg panel-toggle session"
            "$mainMod CTRL,  L,      exec,            noctalia msg session lock"

            # Screenshots
            ",               Print,  exec,            noctalia msg screenshot-region"
            "$mainMod,       Print,  exec,            noctalia msg screenshot-fullscreen"
            "$mainMod ALT,   Print,  exec,            noctalia msg screenshot-fullscreen all"
          ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          # ── Media / hardware keys ────────────────────────────────────
          bindel =
            [
              ",XF86AudioRaiseVolume, exec, noctalia msg volume-up"
              ",XF86AudioLowerVolume, exec, noctalia msg volume-down"
              ",XF86AudioMute, exec, noctalia msg volume-mute"
              ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ]
            ++ lib.optionals isNomad [
              ",XF86MonBrightnessUp, exec, noctalia msg brightness-up"
              ",XF86MonBrightnessDown, exec, noctalia msg brightness-down"
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
              touchpad.natural_scroll = true;
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

          # ── Visual effects ───────────────────────────────────────────
          decoration =
            {rounding = 10;}
            // lib.optionalAttrs isNomad {
              blur.enabled = false;
              shadow.enabled = false;
            };
        }
        // lib.optionalAttrs isNomad {
          # ── Trackpad gestures ───────────────────────────────────────
          gesture = "3, horizontal, workspace";
        };
    };
  };
}
