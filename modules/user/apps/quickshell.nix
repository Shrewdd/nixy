{ pkgs, ... }:

let
  mocha = import ../../shared/theme/catppuccin-mocha-base16.nix;

  configDir = pkgs.writeTextDir "shell.qml" ''
    import QtQuick
    import Quickshell

    // Cozy, minimal status bar matching niri + Catppuccin vibes.
    ShellRoot {
      PanelWindow {
        id: panel
        anchors {
          top: true
          left: true
          right: true
        }
        margins {
          top: 8
          left: 8
          right: 8
        }
        
        implicitHeight: 32

        Rectangle {
          anchors.fill: parent
          color: "#${mocha.base00}"
          border.color: "#${mocha.base02}"
          border.width: 1
          radius: 0
        }

        // Left: Time display
        Text {
          id: timeDisplay
          anchors.left: parent.left
          anchors.leftMargin: 10
          anchors.verticalCenter: parent.verticalCenter

          color: "#${mocha.base05}"
          font.family: "Noto Sans"
          font.pixelSize: 10
          font.weight: Font.Normal

          function fmtTime() {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, '0');
            const mins = String(now.getMinutes()).padStart(2, '0');
            return hours + ':' + mins;
          }

          text: fmtTime()

          Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: timeDisplay.text = timeDisplay.fmtTime()
          }
        }

        // Center: Indicator dot for visual balance
        Rectangle {
          anchors.centerIn: parent
          width: 4
          height: 4
          color: "#${mocha.base0E}"
          radius: 2
          opacity: 0.4
        }

        // Right: Volume placeholder
        Text {
          anchors.right: parent.right
          anchors.rightMargin: 10
          anchors.verticalCenter: parent.verticalCenter

          color: "#${mocha.base05}"
          font.family: "Noto Sans"
          font.pixelSize: 10
          text: "vol: --"
        }
      }
    }
  '';

in
{
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;

    configs.default = configDir;
    activeConfig = "default";

    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
