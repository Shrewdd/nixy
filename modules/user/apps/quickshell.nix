{ pkgs, ... }:

let
  mocha = import ../../shared/theme/catppuccin-mocha-base16.nix;

  configDir = pkgs.writeTextDir "shell.qml" ''
    import QtQuick
    import Quickshell

    // Minimal, sharp, Catppuccin-friendly top bar.
    ShellRoot {
      PanelWindow {
        id: panel
        anchors.top: root.top
        width: root.width
        height: 40

        Rectangle {
          anchors.fill: parent
          color: "#${mocha.base00}"
          border.color: "#${mocha.base02}"
          border.width: 2
          radius: 4
        }

        Text {
          id: timeDisplay
          anchors.left: parent.left
          anchors.leftMargin: 16
          anchors.verticalCenter: parent.verticalCenter

          color: "#${mocha.base05}"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 13
          font.weight: Font.Medium

          function fmtTime() {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            return hours + ':' + minutes;
          }

          text: fmtTime()

          Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: timeDisplay.text = timeDisplay.fmtTime()
          }
        }

        Text {
          anchors.centerIn: parent
          color: "#${mocha.base04}"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 12
          text: "quickshell"
          opacity: 0.6
        }

        Item {
          anchors.right: parent.right
          anchors.rightMargin: 16
          anchors.verticalCenter: parent.verticalCenter
          width: 24
          height: 24

          Rectangle {
            anchors.fill: parent
            color: "#${mocha.base0E}"
            border.color: "#${mocha.base0D}"
            border.width: 2
            radius: 2

            Text {
              anchors.centerIn: parent
              color: "#${mocha.base00}"
              text: "◆"
              font.pixelSize: 12
            }
          }
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
