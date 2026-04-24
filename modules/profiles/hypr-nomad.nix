{
  inputs,
  pkgs,
  lib,
  ...
}: let
  qylockSrc = pkgs.fetchFromGitHub {
    owner = "Darkkal44";
    repo = "qylock";
    rev = "6d676217daef421e1d4abdc99a9307c60ed0d49b";
    sha256 = "sha256-Qq+0hvSMJOmOhzqZet0SOi3N3PMCGd+GvlMArF7t8n0=";
  };

  qylockLastOfUsTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "sddm-theme-qylock-last-of-us";
    version = "6d67621";
    src = qylockSrc;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/sddm/themes/last-of-us"
      cp -r themes/last-of-us/* "$out/share/sddm/themes/last-of-us/"
      runHook postInstall
    '';
  };
in {
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

  services.displayManager.gdm.enable = lib.mkForce false;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${qylockLastOfUsTheme}/share/sddm/themes/last-of-us";
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      qt6Packages.qtmultimedia
      qt6Packages.qt5compat
    ];
  };
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

  services.gnome.gnome-keyring.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    playerctl
    libsecret
    seahorse
    hyprpolkitagent
    imv
    mpv
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault "1";
    XDG_SESSION_TYPE = lib.mkDefault "wayland";
    XDG_SESSION_DESKTOP = lib.mkDefault "Hyprland";
    XDG_CURRENT_DESKTOP = lib.mkDefault "Hyprland";
  };

  home-manager.users.km = {osConfig, ...}: {
    imports = [
      inputs.caelestia-shell.homeManagerModules.default
      ../home/core.nix
      ../home/ghostty.nix
      ../home/zen.nix
      ../home/spotify.nix
    ];

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

        bar.workspaces.perMonitorWorkspaces = false;
      };

      cli = {
        enable = true;
        settings.theme.enableGtk = false;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;

      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "ghostty";
        "$fileManager" = "nautilus";
        "$browser" = "zen-twilight";
        "$wallpaperDir" = "${osConfig.nixy.stylix.wallpaperDir}";

        exec-once = ["hyprpolkitagent"];

        monitor = ["eDP-1,1366x768@60,0x0,1"];

        general = {
          layout = "dwindle";
          border_size = 2;
          gaps_in = 4;
          gaps_out = 10;
        };

        dwindle.preserve_split = true;

        group.groupbar = {
          font_size = 11;
          gradients = false;
        };

        decoration = {
          rounding = 8;
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

        bind = [
          "$mainMod,       RETURN, exec,            $terminal"
          "$mainMod,       E,      exec,            $fileManager"
          "$mainMod,       Q,      killactive,"
          "$mainMod,       M,      exec,            uwsm stop"
          "$mainMod,       V,      togglefloating,"
          "$mainMod,       J,      layoutmsg,       togglesplit"
          "$mainMod,       left,   movefocus,       l"
          "$mainMod,       right,  movefocus,       r"
          "$mainMod,       up,     movefocus,       u"
          "$mainMod,       down,   movefocus,       d"
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
          "$mainMod,       S,      togglespecialworkspace, magic"
          "$mainMod SHIFT, S,      movetoworkspace,        special:magic"
          "$mainMod,       mouse_down, workspace,   e+1"
          "$mainMod,       mouse_up,   workspace,   e-1"
          "$mainMod,       A,      global,          caelestia:launcher"
          "$mainMod,       B,      exec,            $browser"
          "$mainMod,       Escape, global,          caelestia:session"
          "$mainMod,       G,      exec,            caelestia shell gameMode toggle"
          "$mainMod,       L,      global,          caelestia:lock"
          "$mainMod,       W,      exec,            caelestia wallpaper -r $wallpaperDir && caelestia scheme set -m ${osConfig.nixy.stylix.polarity}"
          "$mainMod,       Print,  exec,            caelestia screenshot --freeze"
          ",               Print,  exec,            caelestia screenshot --region --freeze"
          "$mainMod ALT,   Print,  exec,            caelestia screenshot --all --freeze"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];

        bindl = [
          ", XF86AudioNext,  exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay,  exec, playerctl play-pause"
          ", XF86AudioPrev,  exec, playerctl previous"
        ];

        windowrule = [
          "suppress_event maximize, match:class .*"
          "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
        ];

        input = {
          kb_layout = "pl";
          touchpad = {
            natural_scroll = true;
            "tap-to-click" = true;
            clickfinger_behavior = true;
          };
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        env = [
          "XCURSOR_THEME,Bibata-Modern-Ice"
          "XCURSOR_SIZE,24"
        ];

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          vfr = true;
        };
      };
    };
  };
}
