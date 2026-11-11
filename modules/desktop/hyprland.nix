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
    ./noctalia.nix
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

    # ── Hyprland window manager ──────────────────────────────────────
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      configType = "lua";

      settings = let
        # ── Hyprland Lua helpers ─────────────────────────────────────────
        mainMod = "SUPER";
        terminal = "kitty";
        fileManager = "thunar";
        browser = "zen-twilight";

        # `hl.dsp.<name>(args...)` as a raw Lua expression
        dsp = name: args:
          lib.generators.mkLuaInline
          "hl.dsp.${name}(${lib.concatMapStringsSep ", " (lib.generators.toLua {multiline = false;}) args})";
        exec = cmd: dsp "exec_cmd" [cmd];

        # `hl.bind(keys, dispatcher, opts?)`
        bind = keys: dispatcher: {_args = [keys dispatcher];};
        bindWith = opts: keys: dispatcher: {_args = [keys dispatcher opts];};
        bindel = bindWith {
          locked = true;
          repeating = true;
        };
        bindl = bindWith {locked = true;};

        # `hl.curve(name, { type = "bezier", ... })`
        bezier = name: p1: p2: {
          _args = [
            name
            {
              type = "bezier";
              points = [p1 p2];
            }
          ];
        };

        # `hl.animation({ leaf, speed, bezier, style? })`
        animation = leaf: speed: curve: style:
          {
            inherit leaf speed;
            enabled = true;
            bezier = curve;
          }
          // lib.optionalAttrs (style != null) {inherit style;};
      in
        {
          # ── Monitors ─────────────────────────────────────────────────
          monitor =
            if isNomad
            then [
              {
                output = "eDP-1";
                mode = "preferred";
                position = "auto";
                scale = 1;
              }
            ]
            else [
              {
                output = "desc:Samsung Electric Company LS24C33xG H9TX501846";
                mode = "1920x1080@100";
                position = "0x0";
                scale = 1;
              }
              {
                output = "desc:Samsung Electric Company LS24C33xG H9TX501795";
                mode = "1920x1080@100";
                position = "1920x0";
                scale = 1;
              }
            ];

          # ── Layout & gaps ────────────────────────────────────────────
          config.general = {
            gaps_in = 3;
            gaps_out = 6;
          };

          # ── Animations ───────────────────────────────────────────────
          curve = [
            (bezier "easeOutExpo" [0.16 1] [0.3 1])
            (bezier "easeOutCubic" [0.33 1] [0.68 1])
          ];

          animation = [
            (animation "windows" 1.6 "easeOutExpo" "popin 80%")
            (animation "windowsIn" 1.6 "easeOutExpo" "popin 80%")
            (animation "windowsOut" 1.2 "easeOutCubic" "popin 80%")
            (animation "windowsMove" 1.6 "easeOutExpo" null)
            (animation "border" 1.6 "default" null)
            (animation "fade" 1.6 "default" null)
            (animation "workspaces" 1.6 "easeOutExpo" "slide")
          ];

          # ── Keybinds ─────────────────────────────────────────────────
          bind =
            [
              # Launchers
              (bind "${mainMod} + RETURN" (exec terminal))
              (bind "${mainMod} + E" (exec fileManager))
              (bind "${mainMod} + B" (exec browser))

              # Window management
              (bind "${mainMod} + Q" (dsp "window.close" []))
              (bind "${mainMod} + V" (dsp "window.float" [{action = "toggle";}]))

              # Focus
              (bind "${mainMod} + left" (dsp "focus" [{direction = "left";}]))
              (bind "${mainMod} + right" (dsp "focus" [{direction = "right";}]))
              (bind "${mainMod} + up" (dsp "focus" [{direction = "up";}]))
              (bind "${mainMod} + down" (dsp "focus" [{direction = "down";}]))

              # Move window
              (bind "${mainMod} + SHIFT + left" (dsp "window.move" [{direction = "left";}]))
              (bind "${mainMod} + SHIFT + right" (dsp "window.move" [{direction = "right";}]))
              (bind "${mainMod} + SHIFT + up" (dsp "window.move" [{direction = "up";}]))
              (bind "${mainMod} + SHIFT + down" (dsp "window.move" [{direction = "down";}]))
            ]
            # Switch workspace (key 0 is workspace 10)
            ++ map (i: bind "${mainMod} + ${toString (lib.mod i 10)}" (dsp "focus" [{workspace = i;}])) (lib.range 1 10)
            # Move window to workspace
            ++ map (i: bind "${mainMod} + SHIFT + ${toString (lib.mod i 10)}" (dsp "window.move" [{workspace = i;}])) (lib.range 1 10)
            ++ [
              # Special workspace
              (bind "${mainMod} + S" (dsp "workspace.toggle_special" ["magic"]))
              (bind "${mainMod} + SHIFT + S" (dsp "window.move" [{workspace = "special:magic";}]))

              # Noctalia ecosystem actions
              (bind "ALT + TAB" (exec "noctalia msg window-switcher hold"))
              (bind "${mainMod} + A" (exec "noctalia msg panel-toggle launcher"))
              (bind "${mainMod} + Escape" (exec "noctalia msg panel-toggle session"))
              (bind "${mainMod} + CTRL + L" (exec "noctalia msg session lock"))

              # Screenshots
              (bind "Print" (exec "noctalia msg screenshot-region"))
              (bind "${mainMod} + Print" (exec "noctalia msg screenshot-fullscreen"))
              (bind "${mainMod} + ALT + Print" (exec "noctalia msg screenshot-fullscreen all"))

              # Mouse move / resize
              (bind "${mainMod} + mouse:272" (dsp "window.drag" []))
              (bind "${mainMod} + mouse:273" (dsp "window.resize" []))
            ]
            # ── Media / hardware keys ────────────────────────────────────
            ++ [
              (bindel "XF86AudioRaiseVolume" (exec "noctalia msg volume-up"))
              (bindel "XF86AudioLowerVolume" (exec "noctalia msg volume-down"))
              (bindel "XF86AudioMute" (exec "noctalia msg volume-mute"))
              (bindel "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
            ]
            ++ lib.optionals isNomad [
              (bindel "XF86MonBrightnessUp" (exec "noctalia msg brightness-up"))
              (bindel "XF86MonBrightnessDown" (exec "noctalia msg brightness-down"))
            ]
            ++ [
              (bindl "XF86AudioNext" (exec "${lib.getExe pkgs.playerctl} next"))
              (bindl "XF86AudioPause" (exec "${lib.getExe pkgs.playerctl} play-pause"))
              (bindl "XF86AudioPlay" (exec "${lib.getExe pkgs.playerctl} play-pause"))
              (bindl "XF86AudioPrev" (exec "${lib.getExe pkgs.playerctl} previous"))
            ];

          # ── Window rules ─────────────────────────────────────────────
          window_rule = [
            {
              name = "suppress-maximize-events";
              match.class = ".*";
              suppress_event = "maximize";
            }
            {
              name = "fix-xwayland-drags";
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };
              no_focus = true;
            }
          ];

          # ── Input ────────────────────────────────────────────────────
          config.input =
            {kb_layout = "pl";}
            // lib.optionalAttrs isNomad {
              touchpad.natural_scroll = true;
            };

          # ── Cursor ───────────────────────────────────────────────────
          env = [
            {_args = ["XCURSOR_THEME" "Bibata-Modern-Ice"];}
            {_args = ["XCURSOR_SIZE" "24"];}
          ];

          # ── Misc ─────────────────────────────────────────────────────
          config.misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };

          # ── Visual effects ───────────────────────────────────────────
          config.decoration =
            {rounding = 10;}
            // lib.optionalAttrs isNomad {
              blur.enabled = false;
              shadow.enabled = false;
            };
        }
        // lib.optionalAttrs isNomad {
          # ── Trackpad gestures ───────────────────────────────────────
          gesture = {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          };
        };
    };
    # disable hyprland being managed by stylix as noctalia takes care of it
    stylix.targets.hyprland.enable = false;
  };
}
