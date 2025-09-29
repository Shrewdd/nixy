{ config, pkgs, lib, ... }:
let
  cfgDir = ./.; # this directory contains eww.yuck, eww.scss, scripts/
  scripts = [ "cpu.sh" "mem.sh" ];
in {
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = cfgDir;
    enableFishIntegration = true; # optional, adjust if you don't use fish
  };

  # Ensure scripts are executable via home.file attributes (they will already
  # be symlinked by configDir, but we can enforce mode if needed).
  # Using mapAttrs' would be overkill; explicitly set for clarity.
  home.file = {
    ".config/eww/scripts/cpu.sh".executable = true;
    ".config/eww/scripts/mem.sh".executable = true;
  };

  # Launcher convenience script
  home.file.".local/bin/eww-dashboard" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      if ! pgrep -x eww >/dev/null; then
        eww daemon
        sleep 0.15
      fi
      if eww windows | grep -qx dashboard; then
        eww close dashboard
      else
        eww open dashboard
      fi
    '';
    executable = true;
  };

  # (Optional) example systemd user service to auto-open the dashboard.
  # systemd.user.services.eww-dashboard = {
  #   Unit = { Description = "Eww Dashboard"; After = ["graphical-session.target"]; };
  #   Service = { ExecStart = "${pkgs.eww}/bin/eww --config $HOME/.config/eww open dashboard"; Restart = "on-failure"; };
  #   Install = { WantedBy = ["default.target"]; };
  # };
}
