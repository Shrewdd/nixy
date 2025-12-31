{ config, lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  programs.niri.settings = {
    input.mod-key = "Super";
    input.focus-follows-mouse.enable = true;
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
    cursor = {
      theme = "Bibata-Modern-Ice";
      size = 24;
    };
    
    spawn-at-startup = [
      { argv = [ "swww-daemon" ]; }
      # Give the daemon a moment to come up on cold boot.
      { sh = "sleep 0.5; swww img --transition-type wipe --transition-duration 0.35 --transition-fps 100 ${toString ../../shared/wallpapers/catppuccin-mocha/sunset.png}"; }
    ];

    # Minimal binds for daily use
    binds = {
      "Mod+slash" = {
        action."show-hotkey-overlay" = [ ];
        allow-inhibiting = false;
      };
      "Mod+W" = {
        action.spawn = [
          "sh"
          "-c"
          "dir='${toString ../../shared/wallpapers/catppuccin-mocha}'; file=\"$(find \"$dir\" -maxdepth 1 -type f \\\( -iname '*.jpg' -o -iname '*.png' \\\) | shuf -n 1)\"; [ -n \"$file\" ] && swww img --transition-type wipe --transition-duration 0.35 --transition-fps 100 \"$file\""
        ];
        allow-inhibiting = false;
      };
      "Mod+Return" = {
        action.spawn = [ "ghostty" ];
        allow-inhibiting = false;
      };
      "Mod+A" = {
        action.spawn = [ "rofi" "-show" "drun" ];
        allow-inhibiting = false;
      };
      "Mod+Q" = {
        action.close-window = [];
        allow-inhibiting = false;
      };

      "Mod+Tab" = {
        action."toggle-overview" = [];
        allow-inhibiting = false;
      };

      # Workspace basics (by index on focused monitor)
      "Mod+1" = { action."focus-workspace" = [ 1 ]; allow-inhibiting = false; };
      "Mod+2" = { action."focus-workspace" = [ 2 ]; allow-inhibiting = false; };
      "Mod+3" = { action."focus-workspace" = [ 3 ]; allow-inhibiting = false; };
      "Mod+4" = { action."focus-workspace" = [ 4 ]; allow-inhibiting = false; };
      "Mod+5" = { action."focus-workspace" = [ 5 ]; allow-inhibiting = false; };
      "Mod+6" = { action."focus-workspace" = [ 6 ]; allow-inhibiting = false; };
      "Mod+7" = { action."focus-workspace" = [ 7 ]; allow-inhibiting = false; };
      "Mod+8" = { action."focus-workspace" = [ 8 ]; allow-inhibiting = false; };
      "Mod+9" = { action."focus-workspace" = [ 9 ]; allow-inhibiting = false; };

      # Move focused window (column) to workspace by index
      "Mod+Shift+1" = { action."move-column-to-workspace" = [ 1 ]; allow-inhibiting = false; };
      "Mod+Shift+2" = { action."move-column-to-workspace" = [ 2 ]; allow-inhibiting = false; };
      "Mod+Shift+3" = { action."move-column-to-workspace" = [ 3 ]; allow-inhibiting = false; };
      "Mod+Shift+4" = { action."move-column-to-workspace" = [ 4 ]; allow-inhibiting = false; };
      "Mod+Shift+5" = { action."move-column-to-workspace" = [ 5 ]; allow-inhibiting = false; };
      "Mod+Shift+6" = { action."move-column-to-workspace" = [ 6 ]; allow-inhibiting = false; };
      "Mod+Shift+7" = { action."move-column-to-workspace" = [ 7 ]; allow-inhibiting = false; };
      "Mod+Shift+8" = { action."move-column-to-workspace" = [ 8 ]; allow-inhibiting = false; };
      "Mod+Shift+9" = { action."move-column-to-workspace" = [ 9 ]; allow-inhibiting = false; };

      # Escape hatch for buggy apps that inhibit compositor shortcuts
      "Mod+Escape" = {
        action."toggle-keyboard-shortcuts-inhibit" = [];
        allow-inhibiting = false;
      };

      # Audio (PipeWire)
      "XF86AudioRaiseVolume".action.spawn = [ "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+" ];
      "XF86AudioLowerVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
      "XF86AudioMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
      "XF86AudioMicMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];

      # Media (MPRIS)
      "XF86AudioNext".action.spawn = [ "playerctl" "next" ];
      "XF86AudioPrev".action.spawn = [ "playerctl" "previous" ];
      "XF86AudioPlay".action.spawn = [ "playerctl" "play-pause" ];
      "XF86AudioPause".action.spawn = [ "playerctl" "play-pause" ];
      "XF86AudioStop".action.spawn = [ "playerctl" "stop" ];

      # Screenshots (built-in)
      "Print" = {
        action.screenshot = [];
        allow-inhibiting = false;
      };

      # Full focused screen
      "Mod+Print" = {
        action."screenshot-screen" = [];
        allow-inhibiting = false;
      };

      # Focused window
      "Shift+Print" = {
        action."screenshot-window" = [];
        allow-inhibiting = false;
      };
    };

    outputs = {
      left = {
        name = "Samsung Electric Company LS24C33xG H9TX501846";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 100.0;
        };
        position = {
          x = 0;
          y = 0;
        };
        scale = 1;
        focus-at-startup = true;
      };

      right = {
        name = "Samsung Electric Company LS24C33xG H9TX501795";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 100.0;
        };
        position = {
          x = 1920;
          y = 0;
        };
        scale = 1;
      };
    };

    # Avoid requiring unstable niri + xwayland-satellite for now.
    xwayland-satellite.enable = lib.mkDefault false;
  };

  systemd.user.services.polkit-agent = {
    Unit = {
      Description = "Polkit authentication agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
