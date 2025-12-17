{ config, lib, pkgs, ... }:

let
  theme = import ../../../assets/theme/everforest.nix;
  wallpaperDir = "${../../../../assets/wallpapers}";
  powermenuThemePath = "${config.xdg.configHome}/rofi/powermenu/style.rasi";

  wallpaperScript = pkgs.writeShellScriptBin "hypr-wallpaper" ''
    set -euo pipefail

    WALL_DIR="${wallpaperDir}"
    PRIMARY="desc:Samsung Electric Company LS24C33xG H9TX501846"
    SECONDARY="desc:Samsung Electric Company LS24C33xG H9TX501795"

    mapfile -t images < <(find "$WALL_DIR" -maxdepth 4 -type f \
      \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
      -print | sort -f)

    if [ "''${#images[@]}" -eq 0 ]; then
      echo "No images in $WALL_DIR" >&2
      exit 1
    fi

    STATE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}"
    mkdir -p "$STATE_DIR"
    STATE_FILE="$STATE_DIR/hyprpaper-index"

    cur=0
    if [ -f "$STATE_FILE" ]; then
      cur=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
    fi
    [ -z "$cur" ] && cur=0

    idx=$(( (cur + 1) % ''${#images[@]} ))
    img="''${images[$idx]}"
    echo "$idx" > "$STATE_FILE"

    img=$(readlink -f "$img")
    hyprctl hyprpaper preload "$img" >/dev/null 2>&1 || true

    apply_wall() { hyprctl hyprpaper wallpaper "$1","$img" >/dev/null 2>&1 || true; }
    apply_wall "$PRIMARY"
    apply_wall "$SECONDARY"

    notify-send -r 9911 "Wallpaper" "$(basename "$img")" -i "$img" 2>/dev/null || true
  '';

  powerMenuScript = pkgs.writeShellScriptBin "rofi-powermenu" ''
    set -euo pipefail

    uptime_str=$(uptime | awk -F'up ' '{print $2}' | sed 's/, 0 users.*//')

    shutdown='󰐥'
    reboot='󰜉'
    lock=''
    suspend='󰤄'
    logout='󰍃'

    rofi_cmd() {
      rofi -dmenu -p "Uptime: $uptime_str" -mesg "Uptime: $uptime_str" -theme "${powermenuThemePath}"
    }

    confirm_cmd() {
      rofi -dmenu -p 'Confirmation' -mesg 'Are you sure?' -theme "${powermenuThemePath}"
    }

    confirm_exit() {
      printf 'yes\nno\n' | confirm_cmd
    }

    run_rofi() {
      printf '%s\n%s\n%s\n%s\n%s\n' "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | rofi_cmd
    }

    run_cmd() {
      selected=$(confirm_exit || true)
      [ "$selected" != "yes" ] && exit 0

      case "$1" in
        --shutdown) systemctl poweroff ;;
        --reboot) systemctl reboot ;;
        --suspend)
          command -v mpc >/dev/null 2>&1 && mpc -q pause || true
          command -v hyprlock >/dev/null 2>&1 && hyprlock || true
          systemctl suspend
          ;;
        --logout) hyprctl dispatch exit ;;
        --lock)
          command -v hyprlock >/dev/null 2>&1 && hyprlock || true
          ;;
      esac
    }

    chosen=$(run_rofi || true)
    case "$chosen" in
      "$shutdown") run_cmd --shutdown ;;
      "$reboot") run_cmd --reboot ;;
      "$lock") run_cmd --lock ;;
      "$suspend") run_cmd --suspend ;;
      "$logout") run_cmd --logout ;;
    esac
  '';
in
{
  options.hm.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland user configuration";
  };

  config = lib.mkIf config.hm.desktop.hyprland.enable {
    home.packages = with pkgs; [
      hyprpaper
      waybar
      rofi
      dunst
      wl-clipboard
      libnotify
      grim
      slurp
      playerctl
      hyprpolkitagent
      hyprlock
    ];

    xdg.portal.enable = lib.mkDefault true;

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
      };
    };

    services.dunst.enable = lib.mkDefault true;

    programs.rofi = {
      enable = lib.mkDefault true;
      location = lib.mkDefault "center";
      font = lib.mkDefault "Maple Mono NF 10.5";
      theme = {
        configuration = {
          modi = "drun,filebrowser";
          show-icons = true;
          icon-theme = "Papirus-Dark";
          matching = "normal";
          tokenize = true;
          display-drun = "Apps";
          click-to-exit = true;
        };
        "*" = {
          background = "#${theme.base}CC";
          foreground = "#${theme.text}FF";
          accent = "#${theme.peach}69";
          background-tb = "#${theme.surface1}FF";
          border-tb = "#${theme.surface0}FF";
          selected = "linear-gradient(to right, #${theme.surface0}FF, #${theme.peach}69)";
          button = "linear-gradient(#${theme.overlay2}FF)";
          button-selected = "linear-gradient(#${theme.peach}69)";
          active = "linear-gradient(to right, #${theme.teal}FF, #${theme.green}FF)";
          urgent = "#${theme.red}FF";
        };
        window = {
          location = "center";
          anchor = "center";
          border = 2;
          border-radius = 6;
          border-color = "@accent";
          width = 420;
          transparency = "real";
          background-color = "@background";
        };
        mainbox = {
          spacing = 10;
          padding = 20;
          children = [ "inputbar" "mode-switcher" "listview" ];
        };
        inputbar = {
          spacing = 10;
          children = [ "textbox-prompt-colon" "entry" ];
        };
        "textbox-prompt-colon" = {
          padding = [ 10 10 10 12 ];
          border-radius = 4;
          border-color = "@border-tb";
          background-color = "@background-tb";
          text-color = "@foreground";
          str = " ";
        };
        entry = {
          padding = [ 10 12 ];
          border-radius = 4;
          border-color = "@border-tb";
          background-color = "@background-tb";
          text-color = "@foreground";
          placeholder = "Search...";
        };
        listview = {
          columns = 1;
          lines = 5;
          scrollbar = false;
          spacing = 5;
        };
        element = {
          spacing = 16;
          margin = [ 2 0 ];
          padding = 12;
          border-radius = 4;
          background-color = "transparent";
          text-color = "@foreground";
        };
        "element normal.active" = {
          background-image = "@active";
        };
        "element selected.normal" = {
          background-image = "@selected";
        };
        "element-icon" = { size = 28; };
        "element-text" = { vertical-align = 0.5; };
      };
    };

    xdg.configFile."rofi/powermenu/style.rasi".text = ''
      configuration {
        show-icons: false;
        me-select-entry: "";
        me-accept-entry: [ MousePrimary, MouseSecondary, MouseDPrimary ];
      }

      * {
        background:       #${theme.base}CC;
        foreground:       #${theme.text}FF;
        accent:           #${theme.peach}69;
        background-tb:    #${theme.surface1}FF;
        border-tb:        #${theme.surface0}FF;
        selected:         linear-gradient(to right, #${theme.surface0}FF, #${theme.peach}69);
        button:           linear-gradient(#${theme.overlay2}FF);
        button-selected:  linear-gradient(#${theme.peach}69);
        active:           linear-gradient(to right, #${theme.teal}FF, #${theme.green}FF);
        urgent:           #${theme.red}FF;
      }

      window {
        transparency: "real";
        location: center;
        anchor: center;
        width: 450px;
        border: 2px solid;
        border-radius: 10px;
        border-color: @accent;
        background-color: @background;
      }

      mainbox {
        spacing: 15px;
        padding: 30px;
        children: [ "message", "listview" ];
      }

      inputbar { enabled: false; }

      message {
        padding: 12px;
        border-radius: 10px;
        background-color: @background-tb;
        text-color: @foreground;
      }

      listview {
        columns: 5;
        lines: 1;
        spacing: 15px;
        scrollbar: false;
      }

      element {
        padding: 10px;
        border-radius: 10px;
        background-color: transparent;
        text-color: @foreground;
      }

      element-text {
        font: "Symbols Nerd Font 24";
        vertical-align: 0.5;
        horizontal-align: 0.5;
      }

      element selected.normal {
        background-color: @foreground;
        text-color: @background;
      }
    '';

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "ghostty";
        "$fileManager" = "thunar";
        "$menu" = "rofi -show drun";

        "exec-once" = [
          "hyprpolkitagent"
          "waybar"
          "hyprpaper"
        ];

        general = {
          layout = "dwindle";
          border_size = 3;
          "col.active_border" = "${theme.rgb.green} ${theme.rgb.teal} 135deg";
          "col.inactive_border" = theme.rgb.base;
          gaps_in = 2;
          gaps_out = 8;
        };

        dwindle = {
          preserve_split = true;
        };

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
            color = "rgba(0d0f1080)";
            color_inactive = "rgba(00000060)";
          };
        };

        bind = [
          "$mainMod, RETURN, exec, $terminal"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, A, exec, $menu"
          "$mainMod, X, exec, rofi-powermenu"

          "$mainMod, Q, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo"
          "$mainMod, J, togglesplit"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          "$mainMod, W, exec, hypr-wallpaper"

          # Screenshots via grim+slurp
          "$mainMod, Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grim -o "$(hyprctl monitors -j | jq -r ".[0].name" 2>/dev/null || echo 0)" "$f" && wl-copy < "$f" && notify-send -i "$f" "Screenshot Saved" "$f"'"
          ", Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grim -g "$(slurp)" "$f" && wl-copy < "$f" && notify-send -i "$f" "Screenshot Saved" "$f"'"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, bash -c 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk "{print int(\$2*100)}") && notify-send -r 9991 -h int:value:$vol -a "Volume" "Volume: $vol%"'"
          ",XF86AudioLowerVolume, exec, bash -c 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk "{print int(\$2*100)}") && notify-send -r 9991 -h int:value:$vol -a "Volume" "Volume: $vol%"'"
          ",XF86AudioMute, exec, bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@) && if echo "$vol_info" | grep -q MUTED; then notify-send -r 9991 -h int:value:0 -a "Volume" "Volume: Muted"; else vol_num=$(echo "$vol_info" | awk "{print int(\$2*100)}") && notify-send -r 9991 -h int:value:$vol_num -a "Volume" "Volume: $vol_num%"; fi'"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        windowrule = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };
      };
    };

    home.packages = [ wallpaperScript powerMenuScript pkgs.jq ];
  };
}
